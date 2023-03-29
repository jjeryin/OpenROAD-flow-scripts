# OpenROAD Design Contest

[![Build Status](https://jenkins.openroad.tools/buildStatus/icon?job=OpenROAD-flow-scripts-Public%2Fpublic_tests_all%2Fmaster)](https://jenkins.openroad.tools/view/Public/job/OpenROAD-flow-scripts-Public/job/public_tests_all/job/master/)
[![Docs](https://readthedocs.org/projects/openroad-flow-scripts/badge/?version=latest)](https://openroad-flow-scripts.readthedocs.io/en/latest/?badge=latest)

OpenROAD flow scripts (ORFS) is a tool set for achieving no-human-involved RTL-to-GDSII physical design. Designers can use the tool to compile certain PDK to explore the potential design space of the physical layout regarding power, performance, and area (PPA) without fabrication. The ORFS can achieve some sort of optimization automation by AutoTuner, however, it is still in development and needs to be added more comprehensive parameters not only for achieving real full automation but also for user-friendly.


## Improvement for the OpenROAD feature

We followed the OpenROAD documentation to successfully build and run the ORFS in our local server. For manual tuning, we tried to modify the clk\_period and clk\_io\_ptc in SDC file to optimize timing while modifying the core utilization and aspect ratio to optimize area. For using AutoTuner, we installed the required Python3.9 packages and tried 20 trails (default is 10) based on our manually tuned parameter, which is for reducing optimization time, and then we added “fast\_route.tcl” file and modified “config.mk” file under the design directory to run the flow. Additionally, we did post-layout timing fixing to ensure 0 wns.

***AutoTuner improvement:*** Based on our observation during manual tuning the parameters, the lower the clk\_io\_ptc value will help with gaining more clock frequency. This is becasue it is used to calculate the input-output delays and generate the updated constraint or SDC for each stage of the flow. The AutoTuner should also be able to provide the optimal value of clk\_io\_ptc. The modification should be very straightforward: adding and modifying arguments in the `distributed.py`. The modified `distributed-revised.py` can be found [here](https://github.com/jjeryin/OpenROAD-flow-scripts/blob/7nmcontest/flow/util/distributed_revised.py). Basically, we added clk\_io\_ptc arguments in the script accordingly. The AutoTuner will produce a johnson file as shown below:
![image](https://user-images.githubusercontent.com/114622772/228409378-3055c8db-f931-437d-9ab6-83ac2ccb7130.png)

We can see `clk_io_ptc` was added and AutoTuner can tune the parameters.

Then we can modify the corresponding `config.mk` and `constaint.sdc` under the `design/asap7/ibex`, as shown below:
![image](https://user-images.githubusercontent.com/114622772/228409692-ec472062-0010-4b88-98a4-d23f11b613d7.png)

We finally can get the gdsii as shown below
![image](https://user-images.githubusercontent.com/114622772/228410160-832d5ded-aadf-4ebd-b937-ad276bcfc12f.png)

with a fmax = 744.15MHz


## Problems and Challenges

**1. Python environment issue for AutoTuner:** We tried use the code in the tutorial below to install the pakage:
```
python3.9 -m pip3.9 install -U --user 'ray[default,tune]==1.11.0' ax-platform hyperopt nevergrad optuna pandas
python3.9 -m pip3.9 install -U --user colorama==0.4.4 bayesian-optimization==1.4.0
```
But the tool will run forever after inputting the command below in our local machine:
```
python3.9 distributed.py --design ibex --platform asap7 --config ../designs/asap7/ibex/autotuner.json tune
```
We have to switch to the cloud server, and the AutoTuner works on the cloud.

**2. Still need human involvement:** After the flow finished, we need to use `repair_timing -setup` and `repair_timing -hold` to fix the timing issue.

## Future works
We still need to think about a good algorithm to find the best `clk_io_ptc`. Additionally, predicting a good start-tuning value needs to be considered based on different designs. This will help with reducing the time of using AutoTuner to optimize the design. Because the time of contest is very limited, we need to get familiar with the tool, run the flow first, and understand the Python scripts, we would plan to do the additional optimization if we have more time.

## Authors

**Jerry Yin**  University of Virginia, ECE

**Yimin Gao**  University of Virginia, ECE

**Bhupendra S. Reniwal**  University of Virginia, ECE

**Mircea R. Stan**  University of Virginia, ECE


## References

```
@inproceedings{ajayi2019toward,
  title={Toward an open-source digital flow: First learnings from the openroad project},
  author={Ajayi, Tutu and Chhabria, Vidya A and Foga{\c{c}}a, Mateus and Hashemi, Soheil and Hosny, Abdelrahman and Kahng, Andrew B and Kim, Minsoo and Lee, Jeongsup and Mallappa, Uday and Neseem, Marina and others},
  booktitle={Proceedings of the 56th Annual Design Automation Conference 2019},
  pages={1--4},
  year={2019}
}
```

[here](https://vlsicad.ucsd.edu/Publications/Conferences/371/c371.pdf) (PDF).


## License

The OpenROAD-flow-scripts repository (build and run scripts) has a BSD 3-Clause License.
The flow relies on several tools, platforms and designs that each have their own licenses:

- Find the tool license at: `OpenROAD-flow-scripts/tools/{tool}/` or `OpenROAD-flow-scripts/tools/OpenROAD/src/{tool}/`.
- Find the platform license at: `OpenROAD-flow-scripts/flow/platforms/{platform}/`.
- Find the design license at: `OpenROAD-flow-scripts/flow/designs/src/{design}/`.
