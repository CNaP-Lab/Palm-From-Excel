function [] = palm_from_excel(filename,rowNumber,varargin)

    % Authors: John C. Williams, Tram N. B. Nguyen, and Philip N. Tubiolo
    % Stony Brook University School of Medicine
    % Albert Einstein College of Medicine
    
    [~,~,raw] = xlsread(filename);
    disp(['Running palm from file : ' filename '.']);  pause(eps); drawnow;
    disp(['Row number : ' num2str(rowNumber) ':']); pause(eps); drawnow;
    disp(raw(rowNumber,:)'); pause(eps); drawnow;
    
    MULTIPLE_FILE_DELIMITER = ';' ;
    LABEL_STRINGS = {...
        'Output Directory (-o)', ...
        'Input Files (-i)', ...
        'Masks (-m)',...
        'Design matrix (-d)',...
        't-Contrasts (-t)', ...
        'T (TFCE)', ...
        'numPermutations' ...
        'ee/ise', ...
        'corrcon', ...
        'corrmod', ...
        'npc', ...
        'npccon', ...
        'npcmod', ...
        'logp', ...
        'fdr', ...
        'Surface Files (-s)', ...
        'F-Contrasts (-f)', ...
        'Additional options (no -)', ...
        'tfce2d', ...
        'Precision', ...
        'savedof', ...
        'savemetrics', ...
        'saveglm' ...
        };
    
    labelRow = raw(1,:); % First row = labels
    thisPalmCallRow = raw(rowNumber,:);
    
    [~,~,matchColumns] = intersect(upper(LABEL_STRINGS),upper(labelRow),'stable');
    
    col.outputDir = matchColumns(1);
    col.inputFiles = matchColumns(2);
    col.masks = matchColumns(3);
    col.designMatrix = matchColumns(4);
    col.t_contrasts = matchColumns(5);
    col.TFCE = matchColumns(6);
    col.numPermutations = matchColumns(7);
    col.permType = matchColumns(8);
    col.corrcon = matchColumns(9);
    col.corrmod = matchColumns(10);
    col.npc = matchColumns(11);
    col.npccon = matchColumns(12);
    col.npcmod = matchColumns(13);
    col.logp = matchColumns(14);
    col.fdr = matchColumns(15);
    col.surfaceFiles = matchColumns(16);
    col.F_contrasts = matchColumns(17);
    col.additional_options = matchColumns(18);
    col.tfce2d = matchColumns(19);
    col.precision = matchColumns(20);
    col.savedof = matchColumns(21);
    col.savemetrics = matchColumns(22);
    col.saveglm = matchColumns(23);
    
    
    outputDir = thisPalmCallRow{1,col.outputDir};
    inputFiles_text = thisPalmCallRow{1,col.inputFiles};
    masks_text = thisPalmCallRow{1,col.masks};
    designMatrix = thisPalmCallRow{1,col.designMatrix};
    t_contrasts_text = thisPalmCallRow{1,col.t_contrasts};
    permType_text = thisPalmCallRow{1,col.permType};
    numPermutations = thisPalmCallRow{1,col.numPermutations};
    text.T = thisPalmCallRow{1,col.TFCE};
    text.corrcon = thisPalmCallRow{1,col.corrcon};
    text.corrmod = thisPalmCallRow{1,col.corrmod};
    text.npc = thisPalmCallRow{1,col.npc};
    text.npccon = thisPalmCallRow{1,col.npccon};
    text.npcmod = thisPalmCallRow{1,col.npcmod};
    text.logp = thisPalmCallRow{1,col.logp};
    text.fdr = thisPalmCallRow{1,col.fdr};
    surfaceFiles_text = thisPalmCallRow{1,col.surfaceFiles};
    F_contrasts_text = thisPalmCallRow{1,col.F_contrasts};
    additional_options_text = thisPalmCallRow{1,col.additional_options};
    text.tfce2d = thisPalmCallRow{1,col.tfce2d};
    precision_text = thisPalmCallRow{1,col.precision};
    text.savedof = thisPalmCallRow{1,col.savedof};
    text.savemetrics = thisPalmCallRow{1,col.savemetrics};
    text.saveglm = thisPalmCallRow{1,col.saveglm};
    
    palmargs.permType = strcat('-' , lower(permType_text));
    
    text_fieldnames = fieldnames(text);
    
    for i = 1:length(text_fieldnames)
        this_field = text_fieldnames{i};
        
        if (strcmpi(this_field,text.(this_field)) == true)
            palmargs.(this_field) = strcat({'-'}, this_field);
        elseif ( isempty(text.(this_field)) == true || any(isnan(text.(this_field))) )
            palmargs.(this_field) = [];
        else
            errorText = ['Invalid argument. ' 'Row: ' num2str(rowNumber) '. ' 'Argument: ' this_field '. \n' ...
                'Passed option ' text.(this_field) ' is incorrect. \n' ...
                'Option must either match argument name to enable ' '(' this_field ')' ', or the cell must be left empty to disable. \n'];
            error(sprintf(errorText));
        end
        
    end
    
    
    if (~isempty(inputFiles_text) && any(~isnan(inputFiles_text)))
        inputFiles_text = strcat('-i;', {' '} , strrep(inputFiles_text,';','; -i;'));
        inputFiles = strtrim(strsplit(inputFiles_text{1}, MULTIPLE_FILE_DELIMITER));
    else
        inputFiles = [];
    end
    
    if (~isempty(masks_text) && any(~isnan(masks_text)))
        masks_text = strcat('-m;', {' '} , strrep(masks_text,';','; -m;'));
        masks = strtrim(strsplit(masks_text{1}, MULTIPLE_FILE_DELIMITER));
    else
        masks = [];
    end
    
    if (~isempty(surfaceFiles_text) && any(~isnan(surfaceFiles_text)))
        surfaceFiles_text_temp = strcat('-s;', {' '} , strrep(surfaceFiles_text,';','; -s;'));
        surfaceFiles_temp = strtrim(strsplit(surfaceFiles_text_temp{1}, MULTIPLE_FILE_DELIMITER));
        surfaceFiles_temp2 = cellfun(@strsplit,surfaceFiles_temp,'UniformOutput',false);
        surfaceFiles = [surfaceFiles_temp2{:}];
    else
        surfaceFiles = [];
    end
    
    if (~isempty(t_contrasts_text) && any(~isnan(t_contrasts_text)))
        t_contrasts_text = strcat('-t;', {' '} , strrep(t_contrasts_text,';','; -t;'));
        t_contrasts = strtrim(strsplit(t_contrasts_text{1}, MULTIPLE_FILE_DELIMITER));
    else
        t_contrasts = [];
    end
    
    if (~isempty(F_contrasts_text) && any(~isnan(F_contrasts_text)))
        F_contrasts_text = strcat('-f;', {' '} , strrep(F_contrasts_text,';','; -f;'));
        F_contrasts = strtrim(strsplit(F_contrasts_text{1}, MULTIPLE_FILE_DELIMITER));
    else
        F_contrasts = [];
    end
    
    if (~isempty(precision_text) && any(~isnan(precision_text)))
        precision_text = {'-precision', precision_text};
        precision = strtrim(precision_text);
    else
        precision = [];
    end
    
    if (~isempty(additional_options_text) && any(~isnan(additional_options_text)))
        additional_options_text = strcat('-', strrep(additional_options_text,'; ','; -'));
        additional_options = strtrim(strsplit(additional_options_text, MULTIPLE_FILE_DELIMITER));
    else
        additional_options = [];
    end
    
    %     outputDirEndChar = outputDir(end);
    %     if(~strcmpi(outputDirEndChar,filesep))
    %         outputDir(end+1) = filesep;
    %     end
    
    palm_arg_cell = [ ...
        inputFiles, ...
        surfaceFiles, ...
        masks, ...
        {'-d'},{designMatrix}, ...
        t_contrasts, ...
        F_contrasts, ...
        {'-n'},{numPermutations}, ...
        {'-o'},{outputDir}, ...
        palmargs.permType, ...
        palmargs.T, ...
        palmargs.tfce2d ...
        palmargs.logp, ...
        palmargs.fdr, ...
        palmargs.npc, ...
        palmargs.npccon, ...
        palmargs.npcmod, ...
        palmargs.corrcon, ...
        palmargs.corrmod, ...
        palmargs.savedof, ...
        palmargs.savemetrics, ...
        palmargs.saveglm, ...
        precision, ...
        additional_options ...
        ];
    
    for i = 1:length(palm_arg_cell)
        disp(palm_arg_cell{i}); pause(eps); drawnow;
    end
    
    palmString = 'palm';
    for i = 1:length(palm_arg_cell)
        palmString = [palmString ' ' palm_arg_cell{i}];
    end
    palmString = [palmString '\n\n'];
    
    disp(palmString); pause(eps); drawnow;
    
    if (isempty(varargin))
        mkdir(outputDir); pause(eps); drawnow;
        palm( palm_arg_cell{:} ); pause(eps); drawnow;
    else
        output_file_name = varargin{1};
        
        appendToFile = false;
        if (length(varargin) > 1)
            checkAppend = varargin{2};
            appendToFile = strcmpi(checkAppend,'-append');
        end
        
        if (~appendToFile)
            permission = 'wt+';
        else
            permission = 'at+';
        end
        
        fid = fopen(output_file_name, permission); pause(eps); drawnow;
        fprintf(fid, palmString); pause(eps); drawnow;
        fclose(fid); pause(eps); drawnow;
    end
    
    
end
