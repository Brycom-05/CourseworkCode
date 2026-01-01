#include <iostream>
#include <vector>
#include <climits>
#include <algorithm>

using namespace std;
using ll = long long;

// For a candidate strength q = 60d, see if it's possible to cover all cities
bool feasible(int n, int k, vector<int> p, vector<ll> s, ll q) {
	// intervals[] contains the endpoints that the ith city would cover
	vector<pair<ll, ll>> interval(n);
	for (int i = 0; i < n; i++) {
		ll L = s.at(i) - q * (ll)p.at(i);
		ll R = s.at(i) + q * (ll)p.at(i);
		interval.at(i) = { L, R };
	}

	// Sort intervals[] by left endpoint
	sort(interval.begin(), interval.end());

	/*
	Greedy idea:

	i is the index of leftmost city not covered
	j is the index of the city that covers the max distance to the right while covering city i 9x)
	
	If x can't be covered (all L > x or bestR < x), q is infeasible
	else i = index of leftmost city not covered by bestR, and we use 1 more tower
	
	If we cover all cities before using more than k towers, return true, else return false
	*/

	int used = 0;
	int i = 0;
	int j = 0;

	while (i < n && used < k) {
		ll x = s.at(i);
		ll bestR = LLONG_MIN;

		while (j < n && interval.at(j).first <= x) {
			bestR = max(bestR, interval.at(j).second);
			j++;
		}

		if (bestR < x) {
			return false;
		}

		while (i < n && s.at(i) <= bestR) {
			i++;
		}

		used++;
	}

	return (i == n);
}

int main() {
	int C;
	cin >> C;

	for (int tests = 0; tests < C; tests++) {
		int n, k;
		cin >> n >> k;

		vector<int> probs(n);
		for (int i = 0; i < n; i++) {
			cin >> probs.at(i);
		}

		vector<int> cities(n);
		for (int i = 0; i < n; i++) {
			cin >> cities.at(i);
		}

		// Avoid fp math
		vector<ll> scaled_cities(n);
		for (int i = 0; i < n; i++) {
			scaled_cities.at(i) = cities.at(i) * 6000LL;
		}

		// Binary search to find the minimal q value
		ll low = 0;
		ll span = (cities.back() - cities.front());
		ll high = max((ll)1, span * 6000LL * 5LL + 6000LL);

		// Quickly finds a high bound (faster than linear)
		while (!feasible(n, k, probs, scaled_cities, high)) {
			high = high * 2 + 1;
		}

		while (low < high) {
			// >> 1 (bit shift) is equivalent to /2 then trunc
			ll mid = (low + high) >> 1;
			if (feasible(n, k, probs, scaled_cities, mid)) {
				high = mid;
			}
			else {
				low = mid + 1;
			}
		}

		cout << low << '\n';
	}

	return 0;
}