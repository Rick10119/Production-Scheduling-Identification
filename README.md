## README

# Production Scheduling Identification: An Inverse Optimization Approach for Industrial Load Modeling Using Smart Meter Data

Video: https://www.bilibili.com/video/BV1bXQDYcE8Y/?vd_source=18e4b7b95b505bbe9bf571ca4ff73d55

This repository contains data and code for our paper "Production Scheduling Identification: An Inverse Optimization Approach for Industrial Load Modeling Using Smart Meter Data", which has been accepted by IEEE Transactions on Smart Grid.

If you find this code useful for your research, please consider citing our paper:
```bibtex
@article{lyu2024production,
  title={Production Scheduling Identification: An Inverse Optimization Approach for Industrial Load Modeling Using Smart Meter Data},
  author={Ruike Lyu, Hongye Guo, Qinghu Tang, Qixin Chen, Chongqing Kang},
  journal={IEEE Transactions on Smart Grid},
  year={2024},
  publisher={IEEE}
}
```

## File Structure Overview
- `data_prepare` folder: Contains code that utilizes PJM electricity price data and a state-task network (STN) model constructed based on parameters from literature for simulating optimal energy utilization results for these two factories on different dates.
- `results` folder: Contains our results and visualization code.
- `main_cement` and `main_steelpowder`: Main programs for fitting industrial assembly line model parameters through inverse optimization on datasets from cement and steel powder plants. These programs call `add_varDef_and_initVal` for variable definition and initialization, use files starting with `add_` to add various constraints for the inverse optimization problem, and apply our proposed iterative algorithm based on zeroth-order stochastic gradient descent to solve the inverse optimization problem (inverse_optimization).

Please note that this is a standalone research code repository with concise comments (due to my busy Ph.D. schedule). I expect readers to understand the code implementation after reading our paper, rather than solely relying on code comments to grasp the underlying principles.

# Frequently Asked Questions (FAQ) - English Version

## 1. What information is accessible and inaccessible in industrial load modeling?

Information in industrial load modeling can be categorized into three types:

1. **Prior Public Knowledge**:
- Obtainable through internet or expert knowledge
- Independent of specific factory parameters
- Includes standard information like unit energy consumption

2. **Specific Facility Parameters** (not directly accessible):
- Rated power of equipment at each production stage
- Material storage space
- Production goals
- Other facility-specific parameters

3. **Smart Meter Data**:
- 15-minute or hourly average power readings
- Usually available from grid operators or load aggregators
- Not public but usable for modeling

## 2. What are the main innovations of the PSI framework?

The PSI framework's innovations are threefold:

1. **Addressing Incomplete Information**:
- First to propose industrial user modeling using only smart meter data
- Solves the challenge of inaccessible internal parameters due to privacy concerns

2. **Improved STN Model**:
- Introduces mSTN model with linear form
- Adopts per-unit parameter system
- Enables task aggregation

3. **Practical Algorithm Implementation**:
- Designs appropriate loss function
- Uses iterative approach for multi-day data
- Validates feasibility through numerical results

## 3. What does model parameter θ represent? What is its physical interpretation?

Parameter θ includes:
- Rated power of equipment at each production stage
- Material storage space
- Initial material quantities
- Production targets
- Other facility-specific parameters

These parameters directly reflect the physical characteristics and operational constraints of industrial facilities.

## 4. What are the limitations of the PSI method?

The PSI method has several limitations:

1. **Model Assumptions**:
- Assumes production targets remain constant over time
- Doesn't consider equipment start-stop time constraints
- Doesn't account for ramping constraints
- Doesn't include nonlinear production efficiency

2. **Data Requirements**:
- Requires sufficient historical smart meter data
- Needs reliable electricity price data

3. **Application Scope**:
- Mainly suitable for industrial loads that can be described by STN model
- May not be applicable to all types of industrial processes

![image](https://github.com/user-attachments/assets/3392dc91-1d46-48f3-96fa-cc7e0b19fbc9)

## 中文版README

# 生产调度识别：利用智能电表数据的工业负荷参数辨识

这个代码库包含了与我们发表在 IEEE Transactions on Smart Grid 的论文相关的数据和代码。

如果您觉得这些代码对您的研究有帮助，请考虑引用我们的论文。


## 文件结构说明
- `data_prepare` 文件夹: 包含利用PJM电价数据和基于文献中水泥厂和钢厂参数构建的状态-任务网络（STN）模型来模拟这两个工厂在不同日期下的最优能源利用结果的代码。
- `results` 文件夹: 存放了我们的结果和可视化代码。
- `main_cement` 和 `main_steelpowder`: 在水泥厂和钢粉厂数据集上通过逆向优化拟合工业流水线模型参数的主程序。这些程序会调用 `add_varDef_and_initVal` 来定义变量并初始化，调用以 `add_` 开头的几个文件来添加逆向优化问题的不同约束，并应用我们提出的基于零阶随机梯度下降的迭代算法来求解逆向优化问题（inverse_optimization）。

请注意，这是一个独立研究的代码库，我的注释相对简略（因为我是一个忙碌的博士生）。我期望读者在阅读我们的论文后能够理解代码实现，而不仅仅依靠代码注释来理解背后的原理。

# 常见问题解答 (FAQ) - 中文版

## 1. 在工业负荷建模中，哪些信息是可获取的，哪些是不可获取的？

工业负荷建模中的信息可分为三类：

1. **先验公共知识**：
- 可通过互联网或专家知识获取
- 与具体工厂参数无关
- 包括生产过程的单位能耗等标准信息

2. **具体设施参数**（不可直接获取）：
- 各生产阶段设备的额定功率
- 物料存储空间
- 生产目标
- 其他设施特定参数

3. **智能电表数据**：
- 15分钟或每小时的平均功率读数
- 通常可从电网运营商或负荷聚合商处获取
- 虽不公开但可用于建模

## 2. PSI框架的主要创新点是什么？

PSI框架的创新主要体现在三个方面：

1. **解决信息不完整问题**：
- 首次提出仅使用智能电表数据进行工业用户建模
- 解决了因隐私问题无法获取内部参数的挑战

2. **改进STN模型**：
- 提出mSTN模型，保持线性形式
- 采用参数单位制
- 支持任务聚合

3. **实用算法实现**：
- 设计了合适的损失函数
- 采用迭代方式处理多天数据
- 通过数值结果验证了可行性

## 3. 模型参数θ代表什么？有什么物理意义？

参数θ包括：
- 工厂内各生产阶段设备的额定功率
- 物料存储空间
- 初始物料量
- 生产目标
- 其他设施特定参数

这些参数直接反映了工业设施的物理特性和运行约束。

## 4. PSI方法的局限性是什么？

PSI方法存在以下局限：

1. **模型假设**：
- 假设生产目标在一段时间内保持不变
- 未考虑设备启停时间约束
- 未考虑爬坡约束
- 未考虑非线性生产效率

2. **数据要求**：
- 需要足够的历史智能电表数据
- 需要可靠的电价数据

3. **应用范围**：
- 主要适用于可用STN模型描述的工业负荷
- 可能不适用于所有类型的工业过程

