#ifndef _AP4_DECRYPTION_PROCESSOR_H
#define _AP4_DECRYPTION_PROCESSOR_H

#include <atomic>
#include <cstdint>
#include <string>

// A class for decrypting CENC-encrypted data. If AES-NI is present in the CPU, the decryption operation will be hardware-accelerated.
class DecryptionProcessor final {
	
public:
	DecryptionProcessor(const DecryptionProcessor& other) = delete;
	DecryptionProcessor& operator=(const DecryptionProcessor& other) = delete;
	DecryptionProcessor(DecryptionProcessor&& other) = delete;
	DecryptionProcessor& operator=(DecryptionProcessor&& other) = delete;

	/// <summary>Constructs a new decryption processor.</summary>
	explicit DecryptionProcessor();

	/// <summary>Destructor.</summary>
	~DecryptionProcessor();

	/// <summary>Decrypts a buffer of data.</summary>
	/// <param name="buffer">The encrypted buffer to decrypt. This buffer will be overriden with the new decrypted buffer.</param>
	/// <param name="length">The length of the buffer in bytes.</param>
	/// <param name="key_id">The key ID. The key ID must be 16 bytes long (32 characters).</param>
	/// <param name="key">The decryption key. The key must be 16 bytes long (32 characters).</param>
	/// <returns>True if the operation succeeded, false otherwise.</returns>
	bool decrypt(uint8_t* buffer, const uint64_t length, const std::string& key_id, const std::string& key);
	

private:
	/// <summary>Allocate a memory block with alignment suitable for all memory accesses (including vectors if available on the CPU).</summary>
	/// <param name="size">Size in bytes for the memory block to be allocated.</param>
	/// <returns>Pointer to the allocated block, or `nullptr` if the block cannot be allocated.</returns>
	void* av_malloc(size_t size);


	/// <summary>Free a memory block which has been allocated with a function of av_malloc() or av_realloc() family.</summary>
	/// <param name="ptr">Pointer to the memory block which should be freed.</param>
	void av_free(void* ptr);


private:
	// Prevent the class from being instantiated on the heap.

	void* operator new(size_t);          // standard new
	void* operator new(size_t, void*);   // placement new
	void* operator new[](size_t);        // array new
	void* operator new[](size_t, void*); // placement array new


private:
	const std::atomic_size_t max_alloc_size = ATOMIC_VAR_INIT(INT64_MAX);
};

#endif // !_AP4_DECRYPTION_PROCESSOR_H
