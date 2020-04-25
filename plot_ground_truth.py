from data_tools.plot_images import draw_boxes
image_dir = '/data/open_images/train_faces'
anns = '/data/open_images/processed_train/train_faces.json'
output_dir = '/data/open_images/gt_plot_train_faces'
draw_boxes(image_dir, output_dir, anns)
