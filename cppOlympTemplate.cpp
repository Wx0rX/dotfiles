#include <bits/stdc++.h>

using namespace std;

#define fast                                                                   \
    ios_base::sync_with_stdio(false);                                          \
    cin.tie(0);                                                                \
    cout.tie(0)
#define sz(a) (int)a.size()
#define all(a) a.begin(), a.end()
#define vc vector
#define F first
#define S second
#define forin(i, a, b) for (int i = a; i < b; ++i)
#define readgraph(n, g)                                                        \
    for (int i = 0; i < n; ++i) {                                              \
        int u, v;                                                              \
        cin >> u >> v;                                                         \
        --u;                                                                   \
        --v;                                                                   \
        g[u].push_back(v);                                                     \
        g[v].push_back(u);                                                     \
    }
#define int long long

constexpr int INF = numeric_limits<int>::max() >> 1;

template <class T> istream &operator>>(istream &is, vector<T> &a) {
    for (auto &item : a)
        is >> item;
    return is;
}

template <class T> ostream &operator<<(ostream &os, vector<T> &a) {
    size_t n = a.size();
    for (size_t i = 0; i < n; ++i) {
        if (i)
            os << ' ';
        os << a[i];
    }
    return os;
}

/*
mt19937 rnd(chrono::high_resolution_clock().now().time_since_epoch().count());
*/

signed main() {
    return 0;
}
