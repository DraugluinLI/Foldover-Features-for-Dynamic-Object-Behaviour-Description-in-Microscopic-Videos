import cv2
import os
import numpy as np
import matplotlib.pyplot as plt
from keras.models import Model, Sequential
from keras import backend as K
from keras.layers import Dense, Flatten, Input, MaxPooling2D, Activation, ZeroPadding2D, merge, Dropout, Conv2D
import keras
from keras.models import load_model
from scipy.io import loadmat

import scipy.io as scio

import os


# =============================================================================
# Gets the file path within the file
# =============================================================================
def file(file_dir):
    L = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            # if os.path.splitext(file)[1] == '.png':
            # if os.path.splitext(file)[1] == '.jpg':
            if os.path.splitext(file)[1] == '.mat':
                L.append(os.path.join(root, file))
    return L


# =============================================================================

# =============================================================================
# def img_resize(img, img_size, use_datagen=False):
#
#     if (img.shape[0] > img.shape[1]):
#         scale = float(img_size) / float(img.shape[1])
#         img = np.array(cv2.resize(np.array(img), (
#         int(img.shape[0] * scale + 1), img_size))).astype(np.float32)
#     else:
#         scale = float(img_size) / float(img.shape[0])
#         img = np.array(cv2.resize(np.array(img), (
#         img_size, int(img.shape[1] * scale + 1)))).astype(np.float32)
#     # crop the proper size and scale to [-1, 1]
#     img = (img[(img.shape[0] - img_size) // 2:(img.shape[0] - img_size) // 2 + img_size,
#             (img.shape[1] - img_size) // 2:(img.shape[1] - img_size) // 2 + img_size,
#             :]-127)/255
#     if use_datagen:
#         rotation = cv2.getRotationMatrix2D((img_size/2, img_size/2), 30, 1)
#         img = cv2.warpAffine(img, rotation, (img_size, img_size))
#     return img

# =============================================================================

# =============================================================================
# filepath = 'D:\\Cervical_Cancer_Image_Data\\20181030-HICDS04-300\\vegf\\validation\\low_300_global'

# ===============================================================================

# ================================================================================
# =================================
# To simplify path and loop writing
folder1 = '004'
folder2 = '002'
path1 = 'D:\\精子显微分析各种数据集\\筛选目标\\' + folder1 + '\\s_0' + folder1 + '_' + folder2 + '\\s_0' + folder1 + '_' + folder2 + '_object_foleover_3D_slice\\'
path2 = 'D:\\精子显微分析各种数据集\\筛选目标\\' + folder1 + '\\s_0' + folder1 + '_' + folder2 + '\\s_0' + folder1 + '_' + folder2 + '_object_foleover_3D_slice_addfirst_DLfeature\\'
# =================================
for num in range(2,3):
    num1 = str(num)

    if num < 10:
       filepath = path1 + 'y_addfirst_cut_3D\\00' + num1

       out = path2 + 'y\\00' + num1
       judge = os.path.exists(filepath)
    else:
        filepath = path1 + 'y_addfirst_cut_3D\\0' + num1

        out = path2 + 'y\\0' + num1
        judge = os.path.exists(filepath)
    if judge == True:
        L = file(filepath)


        # model = Sequential()
        # # model.add(Input(shape=pic.shape))
        # model.add(Conv2D(filters=4, kernel_size=(7,7), strides=1, input_shape=pic.shape))


        # model = keras.applications.resnet50.ResNet50()
        model = keras.applications.vgg16.VGG16()
        # model = keras.applications.inception_v3.InceptionV3()

        for i in L:
            print(i)

            #pic = cv2.imread(i)

            pic = loadmat(i)
            # pic = cv2.imdecode(np.fromfile(i,dtype=np.uint8),-1)
            # print(pic)
            # cv2.imshow("Image", pic)


            #pic = cv2.resize(pic, (224, 224))


            pic1 = pic['IMG']

            model.summary()
            pic = np.expand_dims(pic1, axis=0)


            # layer_1 = K.function([model.layers[0].input, K.learning_phase()], [model.layers[1].output])
            # f1 = layer_1([pic])[0]

            layer_2 = K.function([model.layers[0].input, K.learning_phase()], [model.layers[-1].output])
            # layer_2 = K.function(input = model.input_1,output = model.get_layer(predictions(Dense)).output)
            f1 = layer_2([pic, 0])[0]
            #    f1 = layer_2(pic)[0]


            if num < 10:
               a = os.path.exists(path2 + 'y\\00' + num1)
            else:
               a = os.path.exists(path2 + 'y\\0' + num1)
            if a == False:
                if num < 10:
                    os.mkdir(path2 + 'y\\00' + num1)
                else:
                    os.mkdir(path2 + 'y\\0' + num1)
            # print(f1)
            filename = i.split('\\')[-1]
            # print(filename)
            # outpath = out +filename#.npy
            #outpath = out + '\\' + filename + '.mat'  # .mat
            outpath = out + '\\' + filename  # .mat
            # print(outpath)
            # np.save(outpath,f1 )#.npy文件
            scio.savemat(outpath, {'f1': f1})  # .mat文件
            # del(pic)
            pic = []
            layer_2 = []
            f1 = []

        # =============================================================================
        # =============================================================================
        # for _ in range(16):
        #    show_img = f1[:, :, :, _+1]
        #    show_img.shape = [104, 104]
        #    plt.subplot(4, 4, _ + 1)
        ##    plt.plot(_)
        #                # plt.imshow(show_img, cmap='black')
        #    plt.imshow(show_img, cmap='gray')
        #    plt.axis('off')
        # plt.show()

