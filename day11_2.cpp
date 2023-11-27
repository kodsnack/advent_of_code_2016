#include <iostream>
#include "pystrlib.hpp"
#include <unordered_map>
#include <map>
#include <set>
#include <queue>

std::unordered_map<std::string, int> mapping;
int c;

inline int get_order(const std::string &str) { return mapping.count(str) ? mapping[str] : (mapping[str] = ++c); }

int n;

struct State {
    
    std::set<int> chip[4], gen[4];
    int f;
    
    bool operator==(const State &s) const {
        if (f != s.f) return false;
        for (int i = 0; i < 4; ++i)
            if (chip[i] != s.chip[i] || gen[i] != s.gen[i]) return false;
        return true;
    }
    
    bool operator<(const State &s) const {
        if (f < s.f) return true;
        if (f > s.f) return false;
        for (int i = 0; i < 4; ++i) {
            if (chip[i] < s.chip[i]) return true;
            if (chip[i] > s.chip[i]) return false;
            if (gen[i] < s.gen[i]) return true;
            if (gen[i] > s.gen[i]) return false;
        }
        return false;
    }

    bool valid() const {
        for (int i = 0; i < 4; ++i)
            for (int v : chip[i])
                if (!gen[i].count(v) && !gen[i].empty()) return false;
        return true;
    }

    std::vector<State> go() const {
        std::vector<State> r;
        for (int c : chip[f]) {
            if (f != 3) {
                State t = *this;
                t.chip[f].erase(c); t.chip[++t.f].insert(c);
                if (t.valid()) r.push_back(t);
            }
            if (f) {
                State t = *this;
                t.chip[f].erase(c); t.chip[--t.f].insert(c);
                if (t.valid()) r.push_back(t);
            }
        }
        for (int g : gen[f]) {
            if (f != 3) {
                State t = *this;
                t.gen[f].erase(g); t.gen[++t.f].insert(g);
                if (t.valid()) r.push_back(t);
            }
            if (f) {
                State t = *this;
                t.gen[f].erase(g); t.gen[--t.f].insert(g);
                if (t.valid()) r.push_back(t);
            }
        }
        for (auto it1 = chip[f].begin(); it1 != chip[f].end(); ++it1)
            for (auto it2 = std::next(it1, 1); it2 != chip[f].end(); ++it2) {
                if (f != 3) {
                    State t = *this;
                    t.chip[f].erase(*it1); t.chip[f].erase(*it2);
                    t.chip[++t.f].insert(*it1); t.chip[t.f].insert(*it2);
                    if (t.valid()) r.push_back(t);
                }
                if (f) {
                    State t = *this;
                    t.chip[f].erase(*it1); t.chip[f].erase(*it2);
                    t.chip[--t.f].insert(*it1); t.chip[t.f].insert(*it2);
                    if (t.valid()) r.push_back(t);
                }
            }
        for (auto it1 = gen[f].begin(); it1 != gen[f].end(); ++it1)
            for (auto it2 = std::next(it1, 1); it2 != gen[f].end(); ++it2) {
                if (f != 3) {
                    State t = *this;
                    t.gen[f].erase(*it1); t.gen[f].erase(*it2);
                    t.gen[++t.f].insert(*it1); t.gen[t.f].insert(*it2);
                    if (t.valid()) r.push_back(t);
                }
                if (f) {
                    State t = *this;
                    t.gen[f].erase(*it1); t.gen[f].erase(*it2);
                    t.gen[--t.f].insert(*it1); t.gen[t.f].insert(*it2);
                    if (t.valid()) r.push_back(t);
                }
            }
        for (auto it1 = chip[f].begin(); it1 != chip[f].end(); ++it1)
            for (auto it2 = gen[f].begin(); it2 != gen[f].end(); ++it2) {
                if (f != 3) {
                    State t = *this;
                    t.chip[f].erase(*it1); t.gen[f].erase(*it2);
                    t.chip[++t.f].insert(*it1); t.gen[t.f].insert(*it2);
                    if (t.valid()) r.push_back(t);
                }
                if (f) {
                    State t = *this;
                    t.chip[f].erase(*it1); t.gen[f].erase(*it2);
                    t.chip[--t.f].insert(*it1); t.gen[t.f].insert(*it2);
                    if (t.valid()) r.push_back(t);
                }
            }
        return r;
    }

    bool end() const {
        for (int i = 0; i < 3; ++i)
            if (!chip[i].empty() || !gen[i].empty()) return false;
        return true;
    }

};

State S;
std::queue<State> Q;
std::map<State, int> step;

int main() {
    S.gen[0].insert(get_order("elerium")); S.chip[0].insert(get_order("elerium"));
    S.gen[0].insert(get_order("dilithium")); S.chip[0].insert(get_order("dilithium"));
    {
        std::string line;
        for (int i = 0; i < 4; ++i) {
            std::getline(std::cin, line);
            std::vector<std::string> v = lib::split(line, " ");
            if (v[4] == "nothing") continue;
            for (unsigned j = 0; j < v.size(); ++j) {
                if (lib::starts_with(v[j], "generator")) S.gen[i].insert(get_order(v[j - 1]));
                else if (lib::starts_with(v[j], "microchip")) S.chip[i].insert(get_order(v[j - 1].substr(0, v[j - 1].size() - 11)));
            }
        }
    }
    step[S] = 0; Q.push(S);
    while (!Q.empty()) {
        State s = Q.front(); Q.pop();
        int v = step[s];
        if (s.end()) {
            std::cout << v << std::endl;
            return 0;
        }
        for (const State &u : s.go()) {
            if (step.count(u)) continue;
            step[u] = v + 1; Q.push(u);
        }
    }
    return 0;
}