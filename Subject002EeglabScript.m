%running eeglab
EEG.etc.eeglabvers = '2022.1'; % this tracks which version of EEGLAB is being used, you may ignore it
%imporing data
EEG = pop_biosig('/mnt/projects/LID_ADAPT/bids/sub-002/eeg/sub-002_task-rest_run-1_eeg.bdf');
EEG.setname='sbj002';
%rejecting 10 channels
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG, 'nochannel',{'GSR1','GSR2','Erg1','Erg2','Resp','Plet','Temp','Ana1','Ana2','Ana3'});
%saving 
EEG.setname='sbj002.136chns';
%imporing channel location file
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'lookup','/home/pouriyah/Downloads/biosemi136.xyz');
EEG = eeg_checkset( EEG );

%ploting 
figure; topoplot([],EEG.chanlocs, 'style', 'blank',  'electrodes', 'labelpoint', 'chaninfo', EEG.chaninfo);
pop_eegplot( EEG, 1, 1, 1);

%deleting extra channles
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG, 'nochannel',{'EXG1','EXG2','EXG3','EXG4','EXG5','EXG6','EXG7','EXG8'});
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG, 'nochannel',{'EXG1','EXG2','EXG3','EXG4','EXG5','EXG6','EXG7','EXG8'});
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'setname','sbj002.128chns','gui','off'); 

%scrolling teh data 
pop_eegplot( EEG, 1, 1, 1);
EG = eeg_checkset( EEG );

%plote spectrum and maps to see the bad channles
figure; pop_spectopo(EEG, 1, [0      79999.5117], 'EEG' , 'freq', [6 10 22], 'freqrange',[2 25],'electrodes','off');

%inspecting bad chanels based on the cahnnel data scrolling
pop_prop( EEG, 1, [1   2   4   6  33  76 87 99 124   ], NaN, {'freqrange',[2 50] })

%saving the new data set by deleting 4 channles (4, 5 , 33, 76), the remaing bad channels => interpolate 
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG, 'nochannel',{'A6','B1','C12'});
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'setname','sbj002.125chns','gui','off'); 

#interpolate chanels numbers 4 and 108
EEG = eeg_checkset( EEG );
pop_prop( EEG, 1, [4  108], NaN, {'freqrange',[2 50] });
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = eeg_checkset( EEG );
EEG = pop_interp(EEG, [4  108], 'spherical');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 6,'setname','sbj002.124chns.interpolated','gui','off'); 
EEG = eeg_checkset( EEG );
figure; pop_spectopo(EEG, 1, [0      79999.5117], 'EEG' , 'freq', [6 10 22], 'freqrange',[2 25],'electrodes','off');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 7,'retrieve',6,'study',0); 

%filtering 
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, 'locutoff',0.1,'hicutoff',50,'plotfreqz',1);
EEG.setname='sbj002.124chns.interpolated.filtered';

%refrencing 
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, [],'exclude',[4 103] );
EEG.setname='sbj002.124chns.interpolated.filtered.ref';

%resampling
EEG = eeg_checkset( EEG );
EEG = pop_resample( EEG, 256);
EEG.setname='sbj002.124chns.interpolated.filtered.ref resampled.resmapled';

%running automatic rejection
EEG = eeg_checkset( EEG );
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
EEG.setname='sbj002.124chns.interpolated.filtered.ref.resampled.auto non chan rej';
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = pop_saveset( EEG, 'filename','sub002.remBadChan.Interpolated.filter.ref.resample.Autorejt(nonChan)','filepath','/home/pouriyah/data-store/');
EEG = eeg_checkset( EEG );

%running  factICA
EEG = eeg_checkset( EEG );
EEG = pop_runica(EEG, 'icatype', 'fastica', 'g','tanh','lastEig',124);
EEG = eeg_checkset( EEG );


