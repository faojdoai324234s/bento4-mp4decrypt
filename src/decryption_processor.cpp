#include "decryption_processor.h"
#include "Ap4CommonEncryption.h"

#include <memory>


/*----------------------------------------------------------------------
|   DecryptionProcessor::DecryptionProcessor
+---------------------------------------------------------------------*/
DecryptionProcessor::DecryptionProcessor() {
	//
}


/*----------------------------------------------------------------------
|   DecryptionProcessor::~DecryptionProcessor
+---------------------------------------------------------------------*/
DecryptionProcessor::~DecryptionProcessor() {
	//
}


/*----------------------------------------------------------------------
|   DecryptionProcessor::decrypt
+---------------------------------------------------------------------*/
bool DecryptionProcessor::decrypt(uint8_t* buffer, const uint64_t length, const std::string& key_id, const std::string& key) {
	
	if (key.size() != 32 || key_id.size() != 32) {
		return false;
	}

	// Create a key map object to hold decryption keys
	unsigned char keyID[16];
	unsigned char decryptionKey[16];
	AP4_ParseHex(key_id.c_str(), keyID, 16);
	AP4_ParseHex(key.c_str(), decryptionKey, 16);

	// create a key map object to hold keys
    	AP4_ProtectionKeyMap keyMap;
	keyMap.SetKeyForKid(keyID, decryptionKey, 16);

	// Create the input stream
	AP4_MemoryByteStream* inputBuffer = new AP4_MemoryByteStream(buffer, length);

	// Create the output stream
	AP4_MemoryByteStream* output = new AP4_MemoryByteStream();

	// Create the decrypting processor and set the decryption keys for it
	AP4_CencDecryptingProcessor* processor = new AP4_CencDecryptingProcessor(&keyMap);

	// Decrypt the file
	const AP4_Result result = processor->Process(*inputBuffer, *output);
	
	// Clean up variables that's not needed anymore
	delete processor;
	inputBuffer->Release();
	
	if (AP4_FAILED(result)) {
		output->Release();
		return false;
	}

	// Prepare the original buffer
	av_free(buffer);
	const uint64_t newSize = output->GetDataSize();
	buffer = (uint8_t*)av_malloc(newSize);

	// Copy the decrypted data back to the original buffer
	memcpy(buffer, output->GetData(), newSize);

	// Clean up the data and return
	output->Release();

	return true;
}


/*----------------------------------------------------------------------
|   DecryptionProcessor::av_malloc
+---------------------------------------------------------------------*/
void* DecryptionProcessor::av_malloc(size_t size) {
	void* ptr = nullptr;

	if (size > std::atomic_load_explicit(&max_alloc_size, std::memory_order_relaxed)) {
		return nullptr;
	}

#if HAVE_POSIX_MEMALIGN
	if (size) //OS X on SDK 10.6 has a broken posix_memalign implementation
		if (posix_memalign(&ptr, ALIGN, size))
			ptr = NULL;
#elif HAVE_ALIGNED_MALLOC
	ptr = _aligned_malloc(size, ALIGN);
#elif HAVE_MEMALIGN
#ifndef __DJGPP__
	ptr = memalign(ALIGN, size);
#else
	ptr = memalign(size, ALIGN);
#endif
	/* Why 64?
	 * Indeed, we should align it:
	 *   on  4 for 386
	 *   on 16 for 486
	 *   on 32 for 586, PPro - K6-III
	 *   on 64 for K7 (maybe for P3 too).
	 * Because L1 and L2 caches are aligned on those values.
	 * But I don't want to code such logic here!
	 */
	 /* Why 32?
	  * For AVX ASM. SSE / NEON needs only 16.
	  * Why not larger? Because I did not see a difference in benchmarks ...
	  */
	  /* benchmarks with P3
	   * memalign(64) + 1          3071, 3051, 3032
	   * memalign(64) + 2          3051, 3032, 3041
	   * memalign(64) + 4          2911, 2896, 2915
	   * memalign(64) + 8          2545, 2554, 2550
	   * memalign(64) + 16         2543, 2572, 2563
	   * memalign(64) + 32         2546, 2545, 2571
	   * memalign(64) + 64         2570, 2533, 2558
	   *
	   * BTW, malloc seems to do 8-byte alignment by default here.
	   */
#else
	ptr = malloc(size);
#endif
	if (!ptr && !size) {
		size = 1;
		ptr = av_malloc(1);
	}
#if CONFIG_MEMORY_POISONING
	if (ptr)
		memset(ptr, FF_MEMORY_POISON, size);
#endif
	return ptr;
}


/*----------------------------------------------------------------------
|   DecryptionProcessor::av_free
+---------------------------------------------------------------------*/
void DecryptionProcessor::av_free(void* ptr) {
#if HAVE_ALIGNED_MALLOC
	_aligned_free(ptr);
#else
	free(ptr);
#endif
}
