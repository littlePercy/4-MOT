% ===========================
% 需求：
% 1. 得到id识别号，
% 2. 对应id的滞留帧数
% 3. 每个id每一帧的荧光强度
% ===========================
img_files = "G:\21 省医蔡婷-信号追踪统计-20231218\05 20231219-GzmB-mNG+mCherry-STX11\ROI\Ctrl";
img_dir = dir(img_files);
excel_files = "Z:\13 算法组\公共区\08-郁帅\04_用户数据分析\result\05\Ctrl";
for kk = 3:length(img_dir)
    % ========== 读取原图 ==========
    img_name = img_dir(kk).name;
    img_file = fullfile(img_files, img_name);
    img_tif = TIf_read(img_file);
    % ========== 读取表格 ==========
    excel_file = fullfile(excel_files,img_name(1:end-4),"DeepSORT.xlsx"); % 指定 Excel 文件的路径
    [~, sheets] = xlsfinfo(excel_file); % 获取 Excel 文件的信息，包括工作表的名称
    % ========== 遍历每个sheet求荧光强度 ========== 
     excelFileName = [img_dir(kk).name(1:end-4), '.xlsx'];    % 保存Excel文件名
    for i = 1:length(sheets)
        % 读取当前工作表的数据
        Data = xlsread(excel_file, sheets{i});
        ID = split(sheets{i}, '_');
        ID_name = ID{end};
        %     ID = str2num(ID{end});
        % 在这里可以对读取到的数据进行处理，比如打印或者进行其他操作
        frame_intensity_lis = [];
        if size(Data,1)>2
            for n = 1:size(Data,1)
                frame = Data(n,1);
                img = img_tif(:,:,frame);
                bbox = Data(n,2:5);
                x1=bbox(1); y1=bbox(2); x2=bbox(3); y2=bbox(4);
                if x1<1
                    x1=1;
                end
                if y1<1
                    y1=1;
                end
                if x2>size(img_tif,2)
                    x2=size(img_tif,2);
                end
                if y2>size(img_tif,1)
                    y2=size(img_tif,1);
                end
                bb = img(y1:y2,x1:x2);
                mean_intensity = func_mean_intensity_extract(bb);
                frame_intensity_lis = [frame_intensity_lis; frame, mean_intensity];
            end
            frame_intensity_lis(:,2) = round(frame_intensity_lis(:,2)/(max(frame_intensity_lis(:,2))),4);
            % 创建table
            T = table(frame_intensity_lis(:,1), frame_intensity_lis(:,2), 'VariableNames', {'帧数', '归一化荧光强度'});
            frame_name = num2str(size(Data,1));
            % 写入Excel，每个ID一个sheet
            writetable(T, excelFileName, 'Sheet', [ID_name,'-',frame_name]);
        end
    end
end
