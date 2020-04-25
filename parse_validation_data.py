images_dir = '/data/open_images/validation'
annotation_csv = '/data/open_images/validation-annotations-bbox.csv'
category_csv = '/data/open_images/class-descriptions-boxable.csv'
output_json = '/data/open_images/val_faces.json'

# Now we read the Open Images categories and parse our data.

import open_images.open_image_to_json as oij
from data_tools.coco_tools import write_json
catmid2name = oij.read_catMIDtoname(category_csv)
oidata = oij.parse_open_images(annotation_csv) # This is a representation of our dataset.

# We only want images that contain the 'Human Face' class, so we run a function that removes all other images.

set1 = oij.reduce_data(oidata, catmid2name, keep_classes=['Human face'])

# Finally we convert this data to COCO format, using this as an opportunity to exclude any annotations 
# that are smaller than 2 x 2 when the input images are resized to maxdim 640, and save to a file.

cocodata = oij.openimages2coco(set1, catmid2name, images_dir, 
                               desc="Open Image validation data, set 1.", 
                               output_class_ids={'Human face': 1}, 
                               max_size=880, min_ann_size=(1,1), 
                               min_ratio=2.0)
write_json(cocodata, output_json)
