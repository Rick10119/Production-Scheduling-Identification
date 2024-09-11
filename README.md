## README

# Production Scheduling Identification: An Inverse Optimization Approach for Industrial Load Modeling Using Smart Meter Data

This repository contains data and code related to my new research project on "Production Scheduling Identification: An Inverse Optimization Approach for Industrial Load Modeling Using Smart Meter Data".

## File Structure Overview
- `data_prepare` folder: Contains code that utilizes PJM electricity price data and a state-task network (STN) model constructed based on parameters from literature for simulating optimal energy utilization results for these two factories on different dates.
- `results` folder: Contains our results and visualization code.
- `main_cement` and `main_steelpowder`: Main programs for fitting industrial assembly line model parameters through inverse optimization on datasets from cement and steel powder plants. These programs call `add_varDef_and_initVal` for variable definition and initialization, use files starting with `add_` to add various constraints for the inverse optimization problem, and apply our proposed iterative algorithm based on zeroth-order stochastic gradient descent to solve the inverse optimization problem (inverse_optimization).

Please note that this is a standalone research code repository with concise comments (due to my busy Ph.D. schedule). I expect readers to understand the code implementation after reading our paper, rather than solely relying on code comments to grasp the underlying principles.

## 中文版README

# 生产调度识别：利用智能电表数据的工业负荷参数辨识

这个代码库包含了我自己编写的与新研究相关的数据和代码，主题是《生产调度识别：利用智能电表数据的工业负荷参数辨识》。

## 文件结构说明
- `data_prepare` 文件夹: 包含利用PJM电价数据和基于文献中水泥厂和钢厂参数构建的状态-任务网络（STN）模型来模拟这两个工厂在不同日期下的最优能源利用结果的代码。
- `results` 文件夹: 存放了我们的结果和可视化代码。
- `main_cement` 和 `main_steelpowder`: 在水泥厂和钢粉厂数据集上通过逆向优化拟合工业流水线模型参数的主程序。这些程序会调用 `add_varDef_and_initVal` 来定义变量并初始化，调用以 `add_` 开头的几个文件来添加逆向优化问题的不同约束，并应用我们提出的基于零阶随机梯度下降的迭代算法来求解逆向优化问题（inverse_optimization）。

请注意，这是一个独立研究的代码库，我的注释相对简略（因为我是一个忙碌的博士生）。我期望读者在阅读我们的论文后能够理解代码实现，而不仅仅依靠代码注释来理解背后的原理。
