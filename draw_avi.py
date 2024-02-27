import cv2
import os
import pandas as pd
import numpy as np
import tifffile

img_path = r"D:\pycharmProjects\others\多目标追踪可视化\00 images"
txt_path = r"D:\pycharmProjects\others\多目标追踪可视化\02 txt"
avi_path = r"D:\pycharmProjects\others\多目标追踪可视化\03 avi"
img_dir = os.listdir(img_path)
for kk in range(len(img_dir)):
    img_name = img_dir[kk]
    file_path = os.path.join(img_path, img_name)
    # 读取三维 TIFF 图像
    tif_stack = tifffile.imread(file_path)
    depth, height, width = tif_stack.shape
    # 读取文本文件
    txt_file = os.path.join(txt_path, img_name[:-4]+".txt")
    data = pd.read_csv(txt_file, sep='\t', header=0)
    # 创建输出视频对象
    output_video_path =  os.path.join(avi_path, img_name[:-4]+".avi")
    fourcc = cv2.VideoWriter_fourcc(*'MJPG')
    output_video = cv2.VideoWriter(output_video_path, fourcc, 10, (width, height))
    # 为每个 ID 分配一个颜色
    colors = np.random.randint(0, 255, size=(data['ID'].nunique(), 3), dtype=np.uint8)
    id_colors = dict(zip(data['ID'].unique(), colors))
    # 遍历每一帧
    for frame_number in range(depth):
        # 读取当前帧
        # image_16bit = tif_stack[frame_number]
        # image_8bit = transfer_16bit_to_8bit(image_16bit)
        image = cv2.cvtColor(tif_stack[frame_number], cv2.COLOR_GRAY2BGR)

        ID = frame_number + 1
        # 在当前帧上绘制每个检测框
        for _, row in data[data['frame'] == ID].iterrows():
            x1, y1, x2, y2 = int(row['x1']), int(row['y1']), int(row['x2']), int(row['y2'])
            box_color = id_colors[row['ID']]
            cv2.rectangle(image, (x1, y1), (x2, y2), tuple(box_color.tolist()), 1)
            cv2.putText(image, str(row['ID']), (x1 - 5, y1 - 5), cv2.FONT_HERSHEY_SIMPLEX, 0.5,
                        tuple(box_color.tolist()), 2)
            # # 显示帧
            # cv2.imshow('Result', image)
            # # 等待用户按下键盘上的某个键
            # cv2.waitKey(0)
            # # 关闭所有窗口
            # cv2.destroyAllWindows()
        # 将当前帧写入输出视频
        output_video.write(image)
    # 释放视频对象
    output_video.release()
    print(f"Video generated and saved to '{output_video_path}'.")
