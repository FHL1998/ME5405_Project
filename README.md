# ME5405_Project ![maven](https://img.shields.io/badge/NUS-ME5405-blue)
## Project Execution
Before execute the project, please add all folders and subfolders to the MATLAB path, and then execute the corresponding files.
- For Chromosome Image1 (`chromo.txt`), the main function file is `chromo.m`
- For Characters Image2 (`charact1.txt`), the main function file is `charact1.m`

## Classification Task ![maven](https://img.shields.io/badge/Conventional-Classification-important)
All 3 methods K-NN, SOM, and SVM are implemented, and the source code are placed in the folder `Classification`.
### SVM
The dataset was transfered from `.mat` to `.png` with binarization operation.

run the file `Classification/SVM/SVM_Char_recog.m`
### K-NN
The main code of KNN-Classifier for execution is :
```matlab
KNN_Run_this.m
```
- To run the KNN-Classifier, the paths of the training data are needed to be changed to your local path. The 'Sample' files are the set used to train while the 'TestingSet; is used to test. The output will be the accuracy.
- The second part applies trained KNN classifier to determine the characters we obtain in the previous task as rearranged.mat. The output will be the corrsponding label of each input. (Noted: The label A B C are labeled as 4 5 6 correspondingly).
