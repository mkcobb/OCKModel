function savePlot(h,name)

saveas(h,fullfile(pwd,'figures','png',sprintf('%s.png',name)));
saveas(h,fullfile(pwd,'figures','eps',sprintf('%s.eps',name)),'epsc');
saveas(h,fullfile(pwd,'figures','fig',sprintf('%s.fig',name)));

end