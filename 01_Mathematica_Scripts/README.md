# 01_Mathematica_Scripts
## Computational Verification Scripts

**Purpose:** Run all computational tests and verification

---

## 📁 Files in This Folder

| File | Purpose | Tests | Status |
|------|---------|-------|--------|
| `verification.wl` | Basic framework tests | 12 | ✅ Complete |
| `advanced_theorems_verification.wl` | Advanced theorem tests | 11 | ✅ Complete |
| `advanced_computations.wl` | Additional computations | - | ✅ Complete |
| `graph_isomorphism_test.wl` | Graph isomorphism research | 36 graphs | ✅ Complete |
| `open_problems_exploration.wl` | Open problem exploration | 3 | ✅ Complete |
| `mathematica_verification.nb` | Mathematica notebook | - | ✅ Complete |

---

## 🚀 How to Run

### Basic Verification
```bash
wolfram -script verification.wl
```
**Expected:** 12/12 tests pass

### Advanced Verification
```bash
wolfram -script advanced_theorems_verification.wl
```
**Expected:** 11/11 tests pass

### Graph Isomorphism Test
```bash
wolfram -script graph_isomorphism_test.wl
```
**Expected:** 36 graphs tested

### Open Problems Exploration
```bash
wolfram -script open_problems_exploration.wl
```
**Expected:** 3 problems explored

---

## 📊 Test Results Summary

### verification.wl (12 tests)
- ✅ Rotation Composition
- ✅ Triangle Holonomy
- ✅ Square Holonomy
- ✅ n-gon Holonomy (n=3,4,5,6,8,12)
- ✅ Euler Characteristic
- ✅ Gauss-Bonnet (Triangle, Square, Pentagon, Hexagon, General, Tetrahedron)
- ✅ Connection Existence

**Result:** 12/12 PASSED (100%)

### advanced_theorems_verification.wl (11 tests)
- ✅ Gauss-Bonnet (5 polyhedra)
- ✅ Connection Existence
- ✅ Holonomy-Curvature Relation
- ✅ Hodge Decomposition (Triangle, Square)
- ✅ Cheeger's Inequality
- ✅ Random Graphs

**Result:** 11/11 PASSED (100%)

### graph_isomorphism_test.wl (36 graphs)
- ✅ Basic Graphs (6): All distinguished
- ✅ Regular Graphs (12): All distinguished
- ✅ Petersen Graph: Unique fingerprint
- ✅ Strongly Regular Graphs: Shrikhande ≠ Rook

**Result:** 34/36 distinguished (94%)

---

## 📝 Requirements

- Mathematica 14.0 or later
- Wolfram Language

---

## 📞 For More Information

- Main README: `../MAIN_README.md`
- Project Overview: `../PROJECT_OVERVIEW.md`
- Complete Index: `../COMPLETE_INDEX.md`

---

**Last Updated:** February 23, 2026  
**Status:** ✅ All Scripts Ready
