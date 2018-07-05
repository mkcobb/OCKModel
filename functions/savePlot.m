function savePlot(h,name)
basepath = fileparts(which('OCKModel.slx'));
saveas(h,fullfile(basepath,'output','figures','png',sprintf('%s.png',name)));
saveas(h,fullfile(basepath,'output','figures','eps',sprintf('%s.eps',name)),'epsc');
saveas(h,fullfile(basepath,'output','figures','fig',sprintf('%s.fig',name)));

end