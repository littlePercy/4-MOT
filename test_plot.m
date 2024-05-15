excel_file = "D:\pycharmProjects\others\多目标追踪可视化\01 xlsx\Sparse_10_488_Em525_Widefield_TIRFSIM-1_Lamp1_SL3_GzmB_NG_Ctrl-1.xlsx";
save_name = 'ID-90.png';
% ========== 读取某个sheet求荧光强度 ========== 
[~, sheets] = xlsfinfo(excel_file); % 获取 Excel 文件的信息，包括工作表的名称
% 读取当前工作表的数据
Data = xlsread(excel_file, sheets{46});
%% 作散点图
x = Data(:,1)';
y = Data(:,2)';
figure,
% scatter(x, y, '.-');
plot(x, y, 'm-', 'LineWidth', 2);
xlabel('frame'), ylabel('intensity')
box off;               % 去除右上坐标标记
set(gca,'linewidth',1) % 设置坐标轴线宽
set(gca,'FontSize',14);
ax = gca;             % current axes
ax.TickDir = 'out';   % 表头向外
saveas(ax, save_name);
