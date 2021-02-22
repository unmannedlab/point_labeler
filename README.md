# Dokered Point Cloud Labeling Tool

 Tool for labeling of a single point clouds or a stream of point clouds. 
 Fork from https://github.com/jbehley/point_labeler
 
 **This fork is specific for [RELLIS-3D dataset](https://github.com/unmannedlab/RELLIS-3D)**
 
<img src="https://user-images.githubusercontent.com/11506664/63230808-340d5680-c212-11e9-8902-bc08f0f64dc8.png" width=500>

 Given the poses of a KITTI point cloud dataset, we load tiles of overlapping point clouds. Thus, multiple point clouds are labeled at once in a certain area. 

## Features
 - Support for KITTI Vision Benchmark Point Clouds.
 - Human-readable label description files in xml allow to define label names, ids, and colors.
 - Modern OpenGL shaders for rendering of even millions of points.
 - Tools for labeling of individual points and polygons.
 - Filtering of labels makes it easy to label even complicated structures with ease.

## Dependencies

* Ubuntu
* Docker
* Nvidia GPU Driver 
* nvidia-docker 
 
## Build
* Install [Ubuntu Docker](https://docs.docker.com/engine/install/ubuntu/)
* Run command 'nvidia-smi' to check nvidia driver
* Install [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) 
* `git clone https://github.com/unmannedlab/point_labeler.git`
* `cd point_labeler`
* `./build_image`


## Usage
Using `./run /path/to/dataset` command to run docker image.
Then run `cd root/catkin_ws/src/point_labeler/bin`, just run `./labeler` to start the labeling tool. 

The labeling tool allows to label a sequence of point clouds in a tile-based fashion, i.e., the tool loads all scans overlapping with the current tile location.
Thus, you will always label the part of the scans that overlaps with the current tile.


In the `settings.cfg` files you can change the followings options:

<pre>

tile size: 100.0   # size of a tile (the smaller the less scans get loaded.)
max scans: 500    # number of scans to load for a tile. (should be maybe 1000), but this currently very memory consuming.
min range: 0.0    # minimum distance of points to consider.
max range: 50.0   # maximum distance of points in the point cloud.

</pre>




 
## Folder structure

When loading a dataset, the data must be organized as follows:

<pre>
point cloud folder
├── os1_cloud_node_kitti_bin/             -- directory containing ".bin" files with Velodyne point clouds.   
├── os1_cloud_node_semantickitti_label_id/   [optional]  -- label directory, will be generated if not present.  
├── pylon_camera_node/  [optional]  -- directory containing ".png" files from the color   camera.  
├── calib.txt             -- calibration of velodyne vs. camera. needed for projection of point cloud into camera.  
└── poses.txt             -- file containing the poses of every scan.
</pre>

 

## Documentation

See the wiki for more information on the usage and other details.


 ## Citation

If you're using the tool in your research, it would be nice if you cite our [paper](https://arxiv.org/abs/1904.01416):

```
@inproceedings{behley2019iccv,
    author = {J. Behley and M. Garbade and A. Milioto and J. Quenzel and S. Behnke and C. Stachniss and J. Gall},
     title = {{SemanticKITTI: A Dataset for Semantic Scene Understanding of LiDAR Sequences}},
 booktitle = {Proc. of the IEEE/CVF International Conf.~on Computer Vision (ICCV)},
      year = {2019}
}
```
[paper](https://arxiv.org/abs/2011.12954):
```
@misc{jiang2020rellis3d,
      title={RELLIS-3D Dataset: Data, Benchmarks and Analysis}, 
      author={Peng Jiang and Philip Osteen and Maggie Wigness and Srikanth Saripalli},
      year={2020},
      eprint={2011.12954},
      archivePrefix={arXiv},
      primaryClass={cs.CV}
}
```
