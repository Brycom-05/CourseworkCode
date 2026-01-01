#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

using namespace std;

// Global variables
const long long NEG_INF = LLONG_MIN / 2;   // Divide by 2 to avoid underflow
vector<vector<pair<int, int>>> adj;        // Adjacency list for DFS later

/*

DFS
Input: u is current node, p is parent node
Returns: pair<int, int> of downU and best where:
            - downU: max. path size starting at u and going down 1 child
            - best: max. path in the subtree overall

*/

pair<long long, long long> dfs(int u, int p) {

    // top1 and top2 track the 2 longest paths starting at u (1 per child)
    // best tracks the longest path found so far in the subtree (either entirely in the subtree or through u)
    long long top1 = NEG_INF, top2 = NEG_INF;
    long long best = NEG_INF;

    // Loop over each child of u
    for (auto v : adj[u]) {

        // Skip the parent node
        if (v.first == p) continue;

        // d is a pair of {downU, best}
        // Recurse into a child
        auto d = dfs(v.first, u);

        // Update best if needed
        best = max(best, d.second);

        // Extend best downward path with connecting edge
        long long cand = d.first + v.second;

        // Update top1 and top2 if needed
        if (cand >= top1) { 
            top2 = top1; 
            top1 = cand; 
        }
        else if (cand > top2) { 
            top2 = cand; 
        }
    }

    // If all edges are negative, don't go down
    long long downU = max(0LL, top1);

    // Check the max weight sum of going down 1 subtree
    best = max(best, top1);

    // If there are more than 1 child, check the max weight sum of the paths that go through u
    if (top2 > NEG_INF) best = max(best, top1 + top2);

    return { downU, best };
}


int main() {
    int N;
    cin >> N;

    // Initialize adjacency list
    adj.assign(N + 1, {});

    // Inputs and fill adjacency list
    int startNode = -1;
    for (int i = 0; i < N - 1; ++i) {
        int u, v, w;
        cin >> u >> v >> w;
        adj[u].push_back({ v, w });
        adj[v].push_back({ u, w });

        // Start node is the first node inputted
        if (startNode == -1) startNode = u;
    }

    // Run DFS from start node
    auto d = dfs(startNode, -1);
    cout << d.second << "\n";

    return 0;
}

/*

Runtime Analysis:

Work: Read inputs + DFS recursion
T(n) <= c*n + O(2(N-1)) = O(N)

*/