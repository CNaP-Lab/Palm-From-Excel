function [] = Example_Main_Palm_From_Excel_Script()
    addpath('/gpfs/projects/VanSnellenbergGroup/Mahek/k_connectivity/Code/spm12/')
    addpath('/gpfs/projects/VanSnellenbergGroup/Mahek/k_connectivity/Code/gifti-main/')
    addpath('/gpfs/projects/VanSnellenbergGroup/Mahek/k_connectivity/Code/PALM-master/')
    addpath('/gpfs/projects/VanSnellenbergGroup/Mahek/k_connectivity/Code/palm_from_excel/')
    
    excelPath = '/gpfs/projects/VanSnellenbergGroup/Mahek/k_connectivity/Code/palm_from_excel/ExcelFiles/Excel_for_Palm.xlsx';
    
    parpool(4);

    parfor i = 2:4
        palm_from_excel(excelPath,i);
    end
end
