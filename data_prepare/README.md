# Data preparation

This repository contains code that utilizes PJM electricity price data and State-Task Network (STN) models constructed based on parameters from a cement plant and a steel plant as described in the literature. The code simulates the optimal energy usage results for these two factories on different dates.

- `aggregate_get_g`: Obtains some aggregate parameters for the steel plant (refer to our PSI paper for the rationale behind aggregation).
- `data_generate_cement` and `data_generate_steelpowder`: Main programs to generate data for the corresponding factories.
- `data_price(_2)`: Script to read price data.
- `load_primal_problem_milp`: Uses the STN model to solve for optimal energy usage results.
- `plot_typical_load`: Plots the typical energy usage of the steel plant for a specific day (various equipment).

The models and data sources are referenced within the code where necessary. For a comprehensive overview, please refer to our PSI paper.

# 数据准备

这个仓库包含的代码主要利用了PJM电价数据和基于文献中水泥厂和钢厂参数构建的状态-任务网络（STN）模型。代码模拟了这两个工厂在不同日期下的最优能源利用结果。

- `aggregate_get_g`：获取钢厂的一些聚合参数（聚合原因请参考我们的PSI论文）。
- `data_generate_cement` 和 `data_generate_steelpowder`：生成对应工厂数据的主要程序。
- `data_price(_2)`：读取价格数据的脚本。
- `load_primal_problem_milp`：使用STN模型求解最优能源利用结果。
- `plot_typical_load`：绘制钢厂特定日期的典型能源利用情况（各种设备）。

模型和数据来源在代码中有相应引用。为了全面了解，请参考我们的PSI论文中的算例设置部分。
