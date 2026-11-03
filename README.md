# 2026-27 西甲前 11 轮：场均进球、射门与控球

一个用 **Vega-Lite** 做的交互图表。不需要安装依赖，双击 `index.html` 就能在浏览器里打开。

## 数据说明

- 统计截止：**2026-11-03**，2026-27 西甲第 11 轮。
- 进球与场次：La Liga 官方积分榜。
- 射门、控球率：AS.com 球队数据。
- **Girona 2026-27 赛季不在西甲**，所以用 **皇家贝蒂斯** 替换。
- 毕尔巴鄂竞技少赛一场（10 场），所以进球和射门统一换算成**场均**，避免总量不可比。
- 控球率为赛季场均百分比。

| 球队 | 已赛 | 总进球 | 总射门 | 场均进球 | 场均射门 | 控球率 |
|---|---:|---:|---:|---:|---:|---:|
| 巴塞罗那 | 11 | 46 | 171 | 4.18 | 15.55 | 69.8 |
| 皇家马德里 | 11 | 28 | 145 | 2.55 | 13.18 | 51.7 |
| 马德里竞技 | 11 | 22 | 134 | 2.00 | 12.18 | 58.6 |
| 皇家贝蒂斯 | 11 | 18 | 139 | 1.64 | 12.64 | 51.9 |
| 毕尔巴鄂竞技 | 10 | 14 | 116 | 1.40 | 11.60 | 53.4 |
| 皇家社会 | 11 | 20 | 110 | 1.82 | 10.00 | 51.5 |

原始表在 `data.csv`。

## 交互功能

- 下拉框：切换“场均进球 / 场均射门 / 控球率”；
- 鼠标悬停：高亮当前柱子，并显示球队、场次、总进球、总射门、控球率；
- 纯前端：一个 HTML 文件 + CDN，不用后端、不用打包。

## 怎么运行

### 方法一：直接打开

双击 `index.html`，用 Edge 或 Chrome 打开。

> 如果页面空白，先检查有没有联网。Vega-Lite 的脚本是从 CDN 加载的。

### 方法二：本地服务器（推荐）

```powershell
cd D:\cs\viz-demo
python -m http.server 8000
```

打开：

```text
http://localhost:8000
```

## 代码结构

1. **引入 Vega-Lite**：

```html
<script src="https://cdn.jsdelivr.net/npm/vega@5"></script>
<script src="https://cdn.jsdelivr.net/npm/vega-lite@5"></script>
<script src="https://cdn.jsdelivr.net/npm/vega-embed@6"></script>
```

2. **准备数据**：见 `data.csv` 或 `index.html` 里的 `data` 数组。

3. **写图表配置**：

```js
const spec = {
  data: { values: data },
  params: [{ name: "metric", value: "goals_pg" }],
  transform: [{ calculate: "datum[metric]", as: "value" }],
  mark: { type: "bar" },
  encoding: {
    y: { field: "team", type: "nominal", sort: "-x" },
    x: { field: "value", type: "quantitative" },
    tooltip: [
      { field: "team", type: "nominal" },
      { field: "value", type: "quantitative" }
    ]
  }
};
```

- `params` 定义一个可变的指标 `metric`；
- `transform.calculate` 把当前指标取出来，放到 `value` 字段；
- `x` 轴绑定 `value`，切换指标时柱子长度自动变化。

4. **下拉框联动**：

```js
let view;

vegaEmbed("#vis", spec).then(result => {
  view = result.view;
});

document.querySelector("#metric").addEventListener("change", e => {
  view.signal("metric", e.target.value).run();
});
```

## 部署到 GitHub Pages

1. 在 GitHub 新建一个空仓库，比如 `laliga-2026-27-viz`；
2. 把 `index.html`、`data.csv`、`README.md` 上传到仓库根目录；
3. 进入仓库 **Settings → Pages**；
4. Source 选 `Deploy from a branch`，分支选 `main`，目录选 `/root`；
5. 等 1–2 分钟，访问：

```text
https://你的用户名.github.io/laliga-2026-27-viz/
```

## 数据来源

- [La Liga 2026-27 官方积分榜](https://www.laliga.com/en-TN/laliga-easports/standing)
- [AS.com 球队射门榜](https://as.com/resultados/futbol/primera/2026_2027/ranking/equipos/disparos/)
- [AS.com 球队控球率榜](https://as.com/resultados/futbol/primera/2026_2027/ranking/equipos/porcentaje-de-posesion/)
