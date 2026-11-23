## 本 PR 做了什么

<!-- 对应 roadmap 的哪一项（F1 / F2 ...） -->

## 自检清单

- [ ] 只实现 roadmap 清单中的一项（或同一文件内不可分的一组）
- [ ] `lake build --iofail` 通过
- [ ] `bash scripts/source-guard.sh` 通过
- [ ] 无 `sorry` / `admit` / `native_decide` / `set_option`
- [ ] `#print axioms` 只含 `propext` / `Classical.choice` / `Quot.sound`
- [ ] 声明名与 `roadmap/LaplaceMethod/Suggested.lean` 完全一致
- [ ] 未修改 `roadmap/`、`rubrics/`、`scripts/`、`.github/`、`lakefile.toml`、`lean-toolchain`
- [ ] 未弱化陈述（结论、假设、定义域均与规格一致）
- [ ] 新增 ≤ 2000 行，单文件 ≤ 1000 行
