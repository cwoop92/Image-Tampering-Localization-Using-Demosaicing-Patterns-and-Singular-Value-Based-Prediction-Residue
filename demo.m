%%
clear all
close all
clc
%%
[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files';'*.*','All Files' },'Open File', pwd);
prompt = {'Block Size (2, 4, 8, 16, 32):'};
dlg_title = 'Input Values';
num_lines = 1;
def = {'16'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

input_image = imread([pathname filename]);
blocksize = str2double(answer{1});

Find_temper= SVDpredict(input_image, blocksize);

subplot(1,2,1), imshow(input_image), title('Image')
subplot(1,2,2), imshow(Find_temper), title('Tampering localization')