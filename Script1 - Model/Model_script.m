
%% Save ML model
x = out.output_ml;
saveCompactModel(trainedModel.RegressionGP,'TrainedModel') 

%% Save hybrid model
x_hybrid = out.output_hybrid;
saveCompactModel(trainedModel1.RegressionGP,'TrainedModel_hybrid') 


%% Test a real ML model
%y = M_BSFC_sim([1700,300,20,0.1,0.4,2,25])

n_sweep = [10 20 30 40 50];
out = zeros(length(n_sweep),1);
for i = 1:length(n_sweep)
    out(i,1) = M_BSFC_sim([1700,450,n_sweep(i),0.2]);
end

figure(1)
plot(n_sweep,out)
xlabel('VGT Sweep'); ylabel('BSFC (g/kWh)')