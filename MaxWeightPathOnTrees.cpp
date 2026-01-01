#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>
#include <stack>

using namespace std;

// Global variables
const long long NEG_INF = LLONG_MIN / 4; // Divide by 4 to avoid underflow

int main() {
	int N;
	cin >> N;

	// Setup an adjacency list for DFS later
	vector<vector<pair<int, int>>> adj;
	adj.assign(N + 1, {});

	// Read input of vertices and edges and their weights
	// Fill the adjacency list
	int startNode = -1;
	for (int i = 0; i < N - 1; i++) {
		int u, v, w;
		cin >> u >> v >> w;

		adj[u].push_back({ v, w });
		adj[v].push_back({ u, w });

		if (startNode == -1) startNode = u;
	}

	/********************************************************************************

	To simulate DFS iteratively, we need:
	1. Parent vector to prevent revisiting the same node
	2. Order vector stores nodes that we visit (root first)
		-> Processing order in reverse gives the children before the parents
	3. Stack keeps track of the current node being processed (starting at the root)

	********************************************************************************/

	vector<int> parent(N + 1, -1);

	vector<int> order;
	order.reserve(N);

	stack<int> st;
	st.push(startNode);

	parent[startNode] = 0;

	/***************************************************************************************
	
	While the stack isn't empty (there are still nodes to process):
	1. Push each node in to order (parents first)
	2. Push each children of the parent being processed onto the stack to be processed later

	***************************************************************************************/
	
	while (!st.empty()) {
		int u = st.top();
		st.pop();
		order.push_back(u);

		for (auto& n : adj[u]) {
			int v = n.first;
			if (v == parent[u]) continue;

			parent[v] = u;
			st.push(v);
		}
	}

	// bestDown[u] = max weight path sum starting at u going down into its subtree
	// bestPath[u] = max weight path sum anywhere inside the subtrees rooted at u (can be fully inside a subtree or through u)
	vector<long long> bestDown(N + 1, 0);
	vector<long long> bestPath(N + 1, NEG_INF);

	// Reverse iteration of order so we process the children first
	for (int i = order.size() - 1; i >= 0; i--) {
		int u = order[i];

		// top1 and top2 will store the 2 largest weight sums of paths in u's children
		long long top1 = NEG_INF, top2 = NEG_INF;

		/*********************************************************************************
		
		For each child:
		1. Find down = best path starting at u going through the child
		2. Update top1 and top2 when necessary
		3. Update bestPath[u] with the max weight path found inside the child's subtrees

		*********************************************************************************/
		
		for (auto& n : adj[u]) {
			if (n.first == parent[u]) continue;

			long long down = bestDown[n.first] + (long long)n.second;
			if (down >= top1) {
				top2 = top1;
				top1 = down;
			}
			else if (down > top2) {
				top2 = down;
			}

			bestPath[u] = max(bestPath[u], top1);
		}

		// Case A: u has at least 1 child
		if (top1 != NEG_INF) {
			// Case 1: best path goes down 1 child
			bestPath[u] = max(bestPath[u], top1);

			// Case 2: best path might go through u connecting 2 children
			if (top2 != NEG_INF) {
				bestPath[u] = max(bestPath[u], top1 + top2);
			}

			// Case 3: if going down is always negative, don't go down
			bestDown[u] = max(0LL, top1);
		}
		// Case B: u has no children
		else {
			bestDown[u] = 0;
			bestPath[u] = max(bestPath[u], 0LL);
		}
	}

	// Scan through all bestPath elements to find the max weight path sum
	long long ans = NEG_INF;
	for (int u = 1; u <= N; u++) {
		ans = max(ans, bestPath[u]);
	}

	cout << ans << '\n';

	return 0;
}

/*

Runtime Analysis

Work: Build adjacency list + DFS prep (making the vectors + while loop) + main loop (iterate once per node + once per all adjacent nodes for that node) + find max over all nodes

T(n) <= c1 * n + c2 * n + O(2(N-1)) + c3 * n
T(n) = O(N)

*/