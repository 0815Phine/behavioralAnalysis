T = readtable("Z:\Histo\Lena_G735\BC_Loss.xlsx");

%x_values = (1:height(T))-(height(T)/2);
x_values = -0.88:-0.05:-0.88+(height(T)-1)*-0.05;

figure
plot(x_values, T.Loss,'Color',[1 0.314 0.314],'LineWidth', 2)
ylabel("BC Loss [%]")
xlabel("Distance from Bregma [mm]")
set(gca, 'XDir', 'reverse')

cs_BC = cumsum(T.BC);
cs_L = cumsum(T.Lesion);

figure, hold on
plot(x_values,cs_BC, 'Color',[0.094 0.502 0.392],'LineWidth', 2)
plot(x_values, cs_L,'Color',[1 0.314 0.314],'LineWidth', 2)
ylabel("Cumulative Area [pixel]")
xlabel("Distance from Bregma [mm]")
set(gca, 'XDir', 'reverse')
legend('BC','Lesion','Box','off','Location','best')