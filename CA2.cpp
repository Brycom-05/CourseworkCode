#include <iostream>
#include <vector>
#include <numeric>
#include <algorithm>
using namespace std;
using ll = long long;

const int MOD = (int)1e9 + 7;

// Modular exponentiation for factorial division
ll modpow(ll a, ll e = MOD - 2) {
    ll r = 1;
    while (e) {
        if (e & 1) r = (r * a) % MOD;
        a = (a * a) % MOD;
        e >>= 1;
    }
    return r;
}

/* Complete the following function that takes as input:
 (i) a 0-indexed array of size n -- representing the city locations
 (ii) a 0-indexed array of size m -- representing potential tower locations
 (iii) an integer d -- the coverage radius of a tower
 and returns as output:
 (i) an array of m integers, where the i^{th} integer denotes the number of ways to place towers at exactly (i+1) out of m locations
     satisfying the constraints in the question
*/
vector<int> computeWays(vector<int>& cities, vector<int>& towers, int d) {
    int n = cities.size(); int m = towers.size();

    // L[i] is the first city the ith tower can cover
    // R[i] is the last city the ith tower can cover
    vector<int> L(m), R(m);

    // find L[i] and R[i] using binary search
    for (int i = 0; i < m; i++) {
        L[i] = lower_bound(cities.begin(), cities.end(), towers[i] - d) - cities.begin();
        R[i] = upper_bound(cities.begin(), cities.end(), towers[i] + d) - cities.begin() - 1;
        R[i] = max(R[i], -1);
    }

    // count towers that covwr no cities
    int z = 0;
    for (int i = 0; i < m; i++) {
        if (R[i] < 0) {
            z++;
        }
    }

    // dp[i][k] = # of ways to use k towers, ending with tower i
    vector<vector<int>> dp(m+1, vector<int>(m + 2, 0));

    // prefix[r][k] = # of ways to cover up to cities[r] using k towers
    vector<vector<int>> prefix(n + 1, vector<int>(m + 2, 0));

    // base case
    for (int i = 0; i < m; i++) {
        if (L[i] == 0 && R[i] >= 0) dp[i][1] = 1;
    }

    // recurrence
    for (int i = 0; i < m; i++) {
        if (L[i] > 0) {
            int prevRight = L[i] - 1;
            if (prevRight >= 0 && prevRight < n) {
                for (int k = 2; k <= m; k++) {
                    dp[i][k] = (dp[i][k] + prefix[prevRight][k - 1]) % MOD;
                }
            }
        }

        // Update prefix for later towers
        if (R[i] >= 0) {
            for (int k = 1; k <= m; k++) {
                prefix[R[i]][k] = (prefix[R[i]][k] + dp[i][k]) % MOD;
            }
        }
    }

    // base_count[t] = # of valid ways to cover all cities using t towers
    vector<ll> base_count(m + 1, 0);
    for (int i = 0; i < m; ++i) {
        if (n > 0 && R[i] == n - 1) {
            for (int used = 1; used <= m; ++used) {
                base_count[used] = (base_count[used] + dp[i][used]) % MOD;
            }
        }
    }

    int MAX = m;

    // fact[i] = i! % MOD
    // invfact[i] = (i!)^(-1) % MOD
    vector<ll> fact(MAX + 1, 1), invfact(MAX + 1, 1);

    // pre-compute factorials to use for convolution later
    for (int i = 1; i <= MAX; ++i) fact[i] = fact[i - 1] * i % MOD;
    invfact[MAX] = modpow(fact[MAX]);
    for (int i = MAX - 1; i >= 0; --i) invfact[i] = invfact[i + 1] * (i + 1) % MOD;

    // computes nCr in O(1) time using precomputed factorials
    auto nCr = [&](int n_, int r_) -> ll {
        if (r_ < 0 || r_ > n_) return 0;
        return fact[n_] * invfact[r_] % MOD * invfact[n_ - r_] % MOD;
    };

    // results
    vector<int> result(m + 1, 0);
    for (int k = 1; k <= m; k++) {
        ll ans = 0;
        for (int t = 1; t <= k; t++) {
            int need = k - t;
            if (need > z) continue;

            // ans = ways to cover all cities using exactly t towers + ways to choose k - t towers that cover no cities from the z empty spots
            ll ways_add = base_count[t] * nCr(z, need) % MOD;
            ans += ways_add;
            if (ans >= MOD) ans -= MOD;
        }
        result[k - 1] = (int)(ans % MOD);
    }

    return result;
}

int main() {
    ios_base::sync_with_stdio(0); cin.tie(0);
    int tc;
    cin >> tc;
    for (int t = 0; t < tc; t++) {
        int n, m, d;
        cin >> n >> m >> d;
        vector<int> cities(n), towers(m);
        for (auto& x : cities) cin >> x;
        for (auto& x : towers) cin >> x;
        auto ways = computeWays(cities, towers, d);
        for (int i = 0; i < m; ++i) {
            cout << ways[i] << " \n"[i == m - 1];
        }
    }
}

// Runtime:
// O(m^2) for most of the algorithm
// O(m log n) for the binary search over cities
// Total: O(m^2 + mlogn)