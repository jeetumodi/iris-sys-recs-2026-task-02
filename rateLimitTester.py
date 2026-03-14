import requests
import time

def test_rate_limiter(url, limit, window_seconds):
    """
    Sends requests rapidly to a URL to test the rate limiter.

    :param url: The endpoint URL to test.
    :param limit: The expected number of allowed requests in the window.
    :param window_seconds: The duration of the rate limit window in seconds.
    """
    print(f"Testing rate limit of {limit} requests per {window_seconds} seconds to {url}")

    allowed_count = 0
    denied_count = 0
    start_time = time.time()

    # Send more than the allowed limit in a short time
    for i in range(limit + 5): 
        response = requests.get(url)
        if response.status_code == 200:
            allowed_count += 1
        elif response.status_code == 429:
            denied_count += 1
        else:
            print(f"Received unexpected status code: {response.status_code}")

        # Optional: Add a small delay to simulate more realistic traffic
        # time.sleep(0.01)

    end_time = time.time()

    print("-" * 30)
    print(f"Total requests sent: {allowed_count + denied_count}")
    print(f"Allowed requests (200 OK): {allowed_count}")
    print(f"Denied requests (429 Too Many Requests): {denied_count}")
    print(f"Time taken: {end_time - start_time:.2f} seconds")

    # Verification
    if allowed_count <= limit and denied_count >= 1:
        print("✅ Test PASSED: Rate limit was enforced correctly.")
    else:
        print("❌ Test FAILED: Rate limit was not enforced as expected.")

# Example usage: Replace with your actual endpoint URL
# Assuming a rate limit of 10 requests per 60 seconds
test_rate_limiter("http://app.localhost", limit=30, window_seconds=60)
