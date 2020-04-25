import open_images.open_image_to_json as oij
oij.copy_images('/data/open_images/val_faces.json',
                '/data/open_images/validation', '/data/open_images/val_faces')
images_dir = ['/data/open_images/train_0%i'%oo for oo in range(9)] # There are nine image directories.        
oij.copy_images('/data/open_images/train_faces.json', images_dir, 
                '/data/open_images/train_faces') 
