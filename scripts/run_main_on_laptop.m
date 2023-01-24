scriptfolder = 'C:\Metacognition_Project\SCRIPTS\metacognition\';

for task_id = [1, 2, 3] % enter position of subjects numbers in main()
    cd(scriptfolder)
    main(task_id)
end