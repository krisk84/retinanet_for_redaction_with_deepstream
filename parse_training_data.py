import open_images.open_image_to_json as oij
from data_tools.coco_tools import write_json

# Definine paths
images_dir = ['/data/open_images/train_0%i'%oo for oo in range(9)] # There are nine image directories.
annotation_csv = '/data/open_images/train-annotations-bbox.csv'
category_csv = '/data/open_images/class-descriptions-boxable.csv'
output_json = '/data/open_images/train_faces.json'

# Read the category names
catmid2name = oij.read_catMIDtoname(category_csv)
# Parse the annotations
oidata = oij.parse_open_images(annotation_csv)

# Keep only human faces
trainset1 = oij.reduce_data(oidata, catmid2name, keep_classes=['Human face'])
cocodata = oij.openimages2coco(trainset1, catmid2name, images_dir, desc="Open Image train data, set 1.", 
                               output_class_ids={'Human face': 1}, 
                               max_size=880, min_ann_size=(1,1), 
                               min_ratio=2.0)
write_json(cocodata, output_json)
