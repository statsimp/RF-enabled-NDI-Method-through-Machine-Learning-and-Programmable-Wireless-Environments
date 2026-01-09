# The core scripts corresponding to the proposed work

This directory contains the main sub-directories that realize the main steps for realizing the RF-enabled NDI pipeline. In particular, these sub-directories consider the following four steps: 

1) **Create_Target_WF** : Here, the scripts creating the target wavefronts based on the assets' similarities are realized. After that, the corresponding DoA information is also being deduced based on the PWE characteristics.

2) **Generate_PWE_graph** : Here, the scripts generate the graph corresponding to the PWE's routing capabilities. In essence, the room is being placed as an input and the SDM edges are deduced.

3) **RT_n_Route** : Here, the scripts that consider the ray-tracing and routing of the RF signals are stored. In essence, here there are two main actions taking place. Initially, a ray-tracing step where 

4) **Post_Process_WF** : Here, the received RF wavefronts are transformed into an intermediate input modality, i.e., an image that translates the RF info to pixel values that can be used by the following ML models.

