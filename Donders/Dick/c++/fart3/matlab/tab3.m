% panel name
% 1  Param-----> timing         leds       recording   plot      rewards
% 2  Acoustic--> main           secondary  filter      stimulus
% 3  Options---> directories    testing
%
% panel code
%   pn10         pn11           pn12       pn13        pn14      pn15
%   pn20         pn21           pn22       pn23        pn24
%   pn30         pn31           pn32
%
% button event
%   tab10        tab11          tab12      tab13       tab14     tab15
%   tab20        tab21          tab22      tab23       tab24
%   tab30        tab31          tab32
%
function varargout = tab3(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tab3_OpeningFcn, ...
                   'gui_OutputFcn',  @tab3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end
% End initialization code - DO NOT EDIT
function figure1_CreateFcn(hObject, eventdata, handles)
end
function tab3_OpeningFcn(hObject, eventdata, handles, varargin)
    loadGlobals(hObject);
    loadExpModel(hObject);
    data = guidata(hObject);
    pos = get(data.figure1,'Position')
    set(data.figure1,'Position',[-30 200 800 600]);
    pos = get(data.figure1,'Position')
%    movegui(data.figure1,'northwest');
    data.tmr = timer('TimerFcn',{@TmrFcn,hObject},'BusyMode','drop',...
                      'ExecutionMode','fixedRate','Period',0.1);
    data.state = 200;
    data.loop = 0;
    data.Trial.current = 0;
    data.Trial.numbers = 0;
    data.outBits = 0;
    data.inpBits = 0;
    pn11Params = struct('Fixation',300,...
                        'TargetFixed',700,...
                        'TargetRandom',2000,...
                        'Random',0,...
                        'TargetChanged',700,...
                        'TargetDuration',0,...
                        'RewardDuration',200);
    pn12Params = struct('Minimum',0,...
                        'Maximum',0,...
                        'FixTar',0,...
                        'FixRed',0,...
                        'FixGreen',1,...
                        'TarRing',0,...
                        'TarSpoke',0,...
                        'TarRed',0,...
                        'TarGreen',1,...
                        'FixIntens',1,...
                        'TarIntens',1,...
                        'TarChanged',7,...
                        'PerChanged',100,...
                        'NoLed',0);
    pn15Params = struct('PressBar',0,...
                        'ReleaseBar',1,...
                        'PressFactor',1,...
                        'Delay',10);
    pn21Params = struct('CarrierM',1000,...
                        'CarrierD',100,...
                        'AttenM',40,...
                        'AttenD',6,...
                        'ModFreqM',10,...
                        'ModFreqD',1,...
                        'ModDepthM',100,...
                        'ModDepthD',0,...
                        'Carrier',0,...
                        'Atten',0,...
                        'ModFreq',0,...
                        'ModDepth',0,...
                        'ModZero',1,...
                        'RippleM',0,...
                        'RippleD',0,...
                        'Semitones',72,...
                        'Components',120,...
                        'PhaseM',90,...
                        'PhaseD',5,...
                        'Ripple',0,...
                        'Phase',0);
    pn31Params = struct('HomeMap','C:\Dick',...
                        'ConfigMap','Config',...
                        'DataMap','Data');
    pn32Params = struct('ontime',500,...
                        'color',1);
    data.save11 = pn11Params;
    data.save12 = pn12Params;
    data.save15 = pn15Params;
    data.save21 = pn21Params;
    data.save31 = pn31Params;
    data.save32 = pn32Params;
    data.output = hObject;
    data.lastActivePanel = 10;
    guidata(hObject, data);
    setDataPanel(hObject,11);
    setDataPanel(hObject,12);
    setDataPanel(hObject,15);
    setDataPanel(hObject,21);
    setDataPanel(hObject,31);
    setDataPanel(hObject,32);
    setActivePanel(hObject,31);
    setupServer(data);
    start(data.tmr);
end
function varargout = tab3_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;
end
function hideSubPanels(hObject,pn)
    data = guidata(hObject);
    PN = fix(pn/10);
    if PN == 1
        set(data.pn11,'Visible','off');
        set(data.pn12,'Visible','off');
%         set(data.pn13,'Visible','off');
%         set(data.pn14,'Visible','off');
        set(data.pn15,'Visible','off');
    end
    if PN == 2
         set(data.pn21,'Visible','off');
%         set(data.pn22,'Visible','off');
%         set(data.pn23,'Visible','off');
%         set(data.pn24,'Visible','off');
    end
    if PN == 3
         set(data.pn31,'Visible','off');
         set(data.pn32,'Visible','off');
    end
    guidata(hObject, data);
end
function switchMainPanel(hObject,PN)
    data = guidata(hObject);
    if PN == 1
        set(data.pn10,'Visible','on');
        set(data.pn20,'Visible','off');
        set(data.pn30,'Visible','off');
    end
    if PN == 2
        set(data.pn10,'Visible','off');
        set(data.pn20,'Visible','on');
        set(data.pn30,'Visible','off');
    end
    if PN == 3
        set(data.pn10,'Visible','off');
        set(data.pn20,'Visible','off');
        set(data.pn30,'Visible','on');
    end
    guidata(hObject, data);
end
function showSubPanel(hObject,pn)
    data = guidata(hObject);
    PN = fix(pn/10);
    if PN == 1
        if (pn == 11)
            set(data.pn11,'Visible','on');
        end
        if (pn == 12)
            set(data.pn12,'Visible','on');
        end
%         if (pn == 13)
%             set(data.pn13,'Visible','on');
%         end
%         if (pn == 14)
%             set(data.pn14,'Visible','on');
%         end
        if (pn == 15)
            set(data.pn15,'Visible','on');
        end
    end
    if PN == 2
        if (pn == 21)
            set(data.pn21,'Visible','on');
        end
    end
    if PN == 3
        if (pn == 31)
            set(data.pn31,'Visible','on');
        end
        if (pn == 32)
            set(data.pn32,'Visible','on');
        end
    end
    data.lastActivePanel = pn;
    guidata(hObject, data);
end
function setActivePanel(hObject, pn)
    data = guidata(hObject);
    PN = fix(pn/10);
    lastPanel = fix(data.lastActivePanel/10);
    if PN ~= lastPanel
        hideSubPanels(hObject,data.lastActivePanel);
        switchMainPanel(hObject,PN);
    else
        hideSubPanels(hObject,pn);
    end
    showSubPanel(hObject,pn);
end
%*****************************************************************
function ok = testNumeric(data, apply)
        str = get(data,'String');
        inp = sscanf(str,'%d');
        if isnumeric(inp)
            set(data,'BackgroundColor',[1.0 1.0 1.0]);
            ok = 0;
        else
            set(data,'BackgroundColor',[1.0 0 0]);
            set(apply,'Enable','off');
            ok = -1;
        end
end
function ok = testDataPanel(hObject, pn)
    data = guidata(hObject);
    ok = 0;
    if pn == 11
        ok = ok + testNumeric(data.pn11Fixation,data.pn11Apply);
        ok = ok + testNumeric(data.pn11TargetFixed,data.pn11Apply);
        ok = ok + testNumeric(data.pn11TargetRandom,data.pn11Apply);
        ok = ok + testNumeric(data.pn11TargetChanged,data.pn11Apply);
        ok = ok + testNumeric(data.pn11RewardDuration,data.pn11Apply);
    end
    if pn == 12
        ok = ok + testNumeric(data.pn12Minimum,data.pn12Apply);
        ok = ok + testNumeric(data.pn12Maximum,data.pn12Apply);
        ok = ok + testNumeric(data.pn12FixIntens,data.pn12Apply);
        ok = ok + testNumeric(data.pn12TarIntens,data.pn12Apply);
        ok = ok + testNumeric(data.pn12TarChanged,data.pn12Apply);
        ok = ok + testNumeric(data.pn12PerChanged,data.pn12Apply);
    end
    if pn == 15
        ok = ok + testNumeric(data.pn15PressFactor,data.pn15Apply);
        ok = ok + testNumeric(data.pn15Delay,data.pn15Apply);
    end
    if pn == 21
        ok = ok + testNumeric(data.pn21CarrierM,data.pn21Apply);
        ok = ok + testNumeric(data.pn21CarrierD,data.pn21Apply);
        ok = ok + testNumeric(data.pn21AttenM,data.pn21Apply);
        ok = ok + testNumeric(data.pn21AttenD,data.pn21Apply);
        ok = ok + testNumeric(data.pn21ModFreqM,data.pn21Apply);
        ok = ok + testNumeric(data.pn21ModFreqD,data.pn21Apply);
        ok = ok + testNumeric(data.pn21ModDepthM,data.pn21Apply);
        ok = ok + testNumeric(data.pn21ModDepthD,data.pn21Apply);
        ok = ok + testNumeric(data.pn21RippleM,data.pn21Apply);
        ok = ok + testNumeric(data.pn21RippleD,data.pn21Apply);
        ok = ok + testNumeric(data.pn21Semitones,data.pn21Apply);
        ok = ok + testNumeric(data.pn21Components,data.pn21Apply);
        ok = ok + testNumeric(data.pn21PhaseM,data.pn21Apply);
        ok = ok + testNumeric(data.pn21PhaseD,data.pn21Apply);
    end
    if pn == 31
        ok = ok; 
    end
    if pn == 32
        ok = ok;
    end
    guidata(hObject, data);
end
function getDataPanel(hObject, pn)
    data = guidata(hObject);
    if pn == 11
        data.save11.Fixation       = sscanf(get(data.pn11Fixation,'String'),'%d');
        data.save11.TargetFixed    = sscanf(get(data.pn11TargetFixed,'String'),'%d');
        data.save11.TargetRandom   = sscanf(get(data.pn11TargetRandom,'String'),'%d');
        data.save11.TargetChanged  = sscanf(get(data.pn11TargetChanged,'String'),'%d');
        data.save11.RewardDuration = sscanf(get(data.pn11RewardDuration,'String'),'%d');
        data.save11.TargetDuration = data.save11.Random;
        set(data.pn11TargetDuration,'String',sprintf('%d',data.save11.TargetDuration));
    end
    if pn == 12
        data.save12.Minimum    = sscanf(get(data.pn12Minimum,'String'),'%d');
        data.save12.Maximum    = sscanf(get(data.pn12Maximum,'String'),'%d');
        data.save12.FixIntens  = sscanf(get(data.pn12FixIntens,'String'),'%d');
        data.save12.TarIntens  = sscanf(get(data.pn12TarIntens,'String'),'%d');
        data.save12.TarChanged = sscanf(get(data.pn12TarChanged,'String'),'%d');
        data.save12.PerChanged = sscanf(get(data.pn12PerChanged,'String'),'%d');
        data.save12.FixTar     = get(data.pn12FixTar,'Value');
        data.save12.NoLed      = get(data.pn12NoLed,'Value');
        data.save12.FixRed     = get(data.pn12FixRed,'Value');
        data.save12.FixGreen   = get(data.pn12FixGreen,'Value');
        data.save12.TarRed     = get(data.pn12TarRed,'Value');
        data.save12.TarGreen   = get(data.pn12TarGreen,'Value');
    end
    if pn == 15
        data.save15.PressBar   = get(data.pn15PressBar,'Value');
        data.save15.ReleaseBar = get(data.pn15ReleaseBar,'Value');
        data.save15.PressFactor = sscanf(get(data.pn15PressFactor,'String'),'%d');
        data.save15.Delay      = sscanf(get(data.pn15Delay,'String'),'%d');
    end
    if pn == 21
        data.save21.CarrierM  = sscanf(get(data.pn21CarrierM,'String'),'%d');
        data.save21.CarrierD  = sscanf(get(data.pn21CarrierD,'String'),'%d');
        data.save21.AttenM    = sscanf(get(data.pn21AttenM,'String'),'%d');
        data.save21.AttenD    = sscanf(get(data.pn21AttenD,'String'),'%d');
        data.save21.ModFreqM  = sscanf(get(data.pn21ModFreqM,'String'),'%d');
        data.save21.ModFreqD  = sscanf(get(data.pn21ModFreqD,'String'),'%d');
        data.save21.ModDepthM = sscanf(get(data.pn21ModDepthM,'String'),'%d');
        data.save21.ModDepthD = sscanf(get(data.pn21ModDepthD,'String'),'%d');
        data.save21.RippleM   = sscanf(get(data.pn21RippleM,'String'),'%d');
        data.save21.RippleD   = sscanf(get(data.pn21RippleD,'String'),'%d');
        data.save21.Semitones = sscanf(get(data.pn21Semitones,'String'),'%d');
        data.save21.Components= sscanf(get(data.pn21Components,'String'),'%d');
        data.save21.PhaseM    = sscanf(get(data.pn21PhaseM,'String'),'%d');
        data.save21.PhaseD    = sscanf(get(data.pn21PhaseD,'String'),'%d');
        data.save21.Carrier  = get(data.pn21Carrier,'Value');
        data.save21.Atten    = get(data.pn21Atten,'Value');
        data.save21.ModFreq  = get(data.pn21ModFreq,'Value');
        data.save21.ModDepth = get(data.pn21ModDepth,'Value');
        data.save21.ModZero  = get(data.pn21ModZero,'Value');
        data.save21.Ripple   = get(data.pn21Ripple,'Value');
        data.save21.Phase    = get(data.pn21Phase,'Value');
    end
    if pn == 31
        data.save31.HomeMap = get(data.pn31Home,'String');
        data.save31.ConfigMap = get(data.pn31Config,'String');
        data.save31.DataMap = get(data.pn31Data,'String');
    end
    if pn == 32
% %         data.save32.ontime = sscanf(get(data.pn32Ontime,'String'),'%d');
% %         data.save32.color  = get(data.pn32Red,'Value');  %1-Red else Green
    end
    guidata(hObject, data);
end
function setDataPanel(hObject, pn)
    data = guidata(hObject);
    if pn == 11
        set(data.pn11Fixation,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn11TargetFixed,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn11TargetRandom,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn11TargetChanged,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn11RewardDuration,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn11Fixation,'String',sprintf('%d',data.save11.Fixation));
        set(data.pn11TargetFixed,'String',sprintf('%d',data.save11.TargetFixed));
        set(data.pn11TargetRandom,'String',sprintf('%d',data.save11.TargetRandom));
        set(data.pn11TargetChanged,'String',sprintf('%d',data.save11.TargetChanged));
        data.save11.TargetDuration = data.save11.Random;
        set(data.pn11TargetDuration,'String',sprintf('%d',data.save11.TargetDuration));
        set(data.pn11RewardDuration,'String',sprintf('%d',data.save11.RewardDuration));
    end
    if pn == 12
        set(data.pn12Minimum,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn12Maximum,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn12FixIntens,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn12TarIntens,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn12TarChanged,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn12PerChanged,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn12Minimum,'String',sprintf('%d',data.save12.Minimum));
        set(data.pn12Maximum,'String',sprintf('%d',data.save12.Maximum));
        set(data.pn12FixIntens,'String',sprintf('%d',data.save12.FixIntens));
        set(data.pn12TarIntens,'String',sprintf('%d',data.save12.TarIntens));
        set(data.pn12TarChanged,'String',sprintf('%d',data.save12.TarChanged));
        set(data.pn12PerChanged,'String',sprintf('%d',data.save12.PerChanged));
        set(data.pn12FixTar,'Value',data.save12.FixTar);
        set(data.pn12NoLed,'Value',data.save12.NoLed);
        set(data.pn12FixRed,'Value',data.save12.FixRed);
        set(data.pn12FixGreen,'Value',data.save12.FixGreen);
        set(data.pn12TarRed,'Value',data.save12.TarRed);
        set(data.pn12TarGreen,'Value',data.save12.TarGreen);
    end
    if pn == 15
        set(data.pn15PressFactor,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn15Delay,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn15PressBar,'Value',data.save15.PressBar);
        set(data.pn15ReleaseBar,'Value',data.save15.ReleaseBar);
        set(data.pn15PressFactor,'String',sprintf('%d',data.save15.PressFactor));
        set(data.pn15Delay,'String',sprintf('%d',data.save15.Delay));
    end
    if pn == 21
        set(data.pn21CarrierM,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21CarrierD,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21AttenM,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21AttenD,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21ModFreqM,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21ModFreqD,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21ModDepthM,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21ModDepthD,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21RippleM,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21RippleD,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21Semitones,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21Components,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21PhaseM,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21PhaseD,'BackgroundColor',[1.0 1.0 1.0]);
        set(data.pn21CarrierM,'String',sprintf('%d',data.save21.CarrierM));
        set(data.pn21CarrierD,'String',sprintf('%d',data.save21.CarrierD));
        set(data.pn21AttenM,'String',sprintf('%d',data.save21.AttenM));
        set(data.pn21AttenD,'String',sprintf('%d',data.save21.AttenD));
        set(data.pn21ModFreqM,'String',sprintf('%d',data.save21.ModFreqM));
        set(data.pn21ModFreqD,'String',sprintf('%d',data.save21.ModFreqD));
        set(data.pn21ModDepthM,'String',sprintf('%d',data.save21.ModDepthM));
        set(data.pn21ModDepthD,'String',sprintf('%d',data.save21.ModDepthD));
        set(data.pn21RippleM,'String',sprintf('%d',data.save21.RippleM));
        set(data.pn21RippleD,'String',sprintf('%d',data.save21.RippleD));
        set(data.pn21Semitones,'String',sprintf('%d',data.save21.Semitones));
        set(data.pn21Components,'String',sprintf('%d',data.save21.Components));
        set(data.pn21PhaseM,'String',sprintf('%d',data.save21.PhaseM));
        set(data.pn21PhaseD,'String',sprintf('%d',data.save21.PhaseD));
        set(data.pn21Carrier,'Value',data.save21.Carrier);
        set(data.pn21Atten,'Value',data.save21.Atten);
        set(data.pn21ModFreq,'Value',data.save21.ModFreq);
        set(data.pn21ModDepth,'Value',data.save21.ModDepth);
        set(data.pn21ModZero,'Value',data.save21.ModZero);
        set(data.pn21Ripple,'Value',data.save21.Ripple);
        set(data.pn21Phase,'Value',data.save21.Phase);
    end
    if pn == 31
        set(data.pn31Home,'String',data.save31.HomeMap);
        set(data.pn31Config,'String',data.save31.ConfigMap);
        set(data.pn31Data,'String',data.save31.DataMap);
    end
    if pn == 32
% %         set(data.pn32Ontime,'String',sprintf('%d',data.save32.ontime));
% %         if (data.save32.color == 0)
% %             set(data.pn32Red,'Value',1);
% %             set(data.pn32Green,'Value',0);
% %         else
% %             set(data.pn32Red,'Value',0);
% %             set(data.pn32Green,'Value',1);
% %         end
    end
    guidata(hObject, data);
end
%=================================================================
%   TAB - Parameter Setting - Acoustic stimuli - Options
%=================================================================
function tab10_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 11);
end
function tab20_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 21);
end
function tab30_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 31);
end
%=================================================================
% Parameter setting-> Timing - Leds - Recording - Plot - Rewards
%=================================================================
function tab11_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 11);
end
function tab12_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 12);
end
function tab13_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 13);
end
function tab14_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 14);
end
function tab15_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 15);
end
%------------------------- timing --------------------------------
function pn11Fixation_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn11TargetFixed_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn11TargetRandom_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn11TargetChanged_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn11TargetDuration_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn11RewardDuration_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn11Fixation_Callback(hObject, eventdata, handles)
end
function pn11TargetFixed_Callback(hObject, eventdata, handles)
end
function pn11TargetRandom_Callback(hObject, eventdata, handles)
end
function pn11TargetChanged_Callback(hObject, eventdata, handles)
end
function pn11RewardDuration_Callback(hObject, eventdata, handles)
end
function pn11OK_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    if testDataPanel(hObject, 11) == 0
        set(data.pn11Apply,'Enable','on');
    else
        set(data.pn11Apply,'Enable','off');
    end
    guidata(hObject, data);
end
function pn11Cancel_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    setDataPanel(hObject,11);
    set(data.pn11Apply,'Enable','off');
    guidata(hObject, data);
end
function pn11Apply_Callback(hObject, eventdata, handles)
    if testDataPanel(hObject, 11) == 0
            %q VERPLAATSEN NAAR HET EIND VAN EEN NIEUWE TRIAL
            data = guidata(hObject);
            data.save11.Random = fix(rand*data.save11.TargetRandom);
            guidata(hObject, data);
        getDataPanel(hObject,11);
    end
    data = guidata(hObject);
    set(data.pn11Apply,'Enable','off');
    guidata(hObject, data);
end
%------------------------- leds ----------------------------------
function pn12Minimum_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn12Maximum_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn12FixIntens_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn12TarIntens_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn12TarChanged_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn12PerChanged_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn12Maximum_Callback(hObject, eventdata, handles)
end
function pn12Minimum_Callback(hObject, eventdata, handles)
end
function pn12PerChanged_Callback(hObject, eventdata, handles)
end
function pn12TarChanged_Callback(hObject, eventdata, handles)
end
function pn12TarIntens_Callback(hObject, eventdata, handles)
end
function pn12FixIntens_Callback(hObject, eventdata, handles)
end
function pn12FixTar_Callback(hObject, eventdata, handles)
end
function pn12FixRed_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    set(data.pn12FixRed,'Value',1);
    set(data.pn12FixGreen,'Value',0);
    guidata(hObject, data);
end
function pn12FixGreen_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    set(data.pn12FixRed,'Value',0);
    set(data.pn12FixGreen,'Value',1);
    guidata(hObject, data);
end
function pn12TarRed_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    set(data.pn12TarRed,'Value',1);
    set(data.pn12TarGreen,'Value',0);
    guidata(hObject, data);
end
function pn12TarGreen_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    set(data.pn12TarRed,'Value',0);
    set(data.pn12TarGreen,'Value',1);
    guidata(hObject, data);
end
function pn12NoLed_Callback(hObject, eventdata, handles)
end
function pn12OK_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    if testDataPanel(hObject, 12) == 0
        set(data.pn12Apply,'Enable','on');
    else
        set(data.pn12Apply,'Enable','off');
    end
    guidata(hObject, data);
end
function pn12Cancel_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    setDataPanel(hObject,12);
    set(data.pn12Apply,'Enable','off');
    guidata(hObject, data);
end
function pn12Apply_Callback(hObject, eventdata, handles)
    if testDataPanel(hObject, 12) == 0
        getDataPanel(hObject,12);
    end
    data = guidata(hObject);
    set(data.pn12Apply,'Enable','off');
    guidata(hObject, data);
end
%----------------------- recording -------------------------------
%------------------------- plot ----------------------------------
%------------------------ rewards --------------------------------
function pn15Delay_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn15PressFactor_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn15PressFactor_Callback(hObject, eventdata, handles)
end
function pn15Delay_Callback(hObject, eventdata, handles)
end
function pn15ReleaseBar_Callback(hObject, eventdata, handles)
end
function pn15PressBar_Callback(hObject, eventdata, handles)
end
function pn15OK_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    if testDataPanel(hObject, 15) == 0
        set(data.pn15Apply,'Enable','on');
    else
        set(data.pn15Apply,'Enable','off');
    end
    guidata(hObject, data);
end
function pn15Cancel_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    setDataPanel(hObject,15);
    set(data.pn15Apply,'Enable','off');
    guidata(hObject, data);
end
function pn15Apply_Callback(hObject, eventdata, handles)
    if testDataPanel(hObject, 15) == 0
        getDataPanel(hObject,15);
    end
    data = guidata(hObject);
    set(data.Apply15,'Enable','off');
    guidata(hObject, data);
end
%=================================================================
% Acoustic stimuli-> Main - Secondary - Filter - Stimulus type
%=================================================================
function tab21_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 21);
end
function tab22_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 22);
end
function tab23_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 23);
end
function tab24_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 24);
end
%---------------------- main parameters --------------------------
function pn21TestRipple_Callback(hObject, eventdata, handles)
end
function pn21TestNoise_Callback(hObject, eventdata, handles)
end
function pn21CarrierM_Callback(hObject, eventdata, handles)
end
function pn21CarrierM_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function pn21CarrierD_Callback(hObject, eventdata, handles)
end
function pn21CarrierD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function pn21RippleM_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21RippleD_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21Semitones_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21Components_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21PhaseM_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21PhaseD_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21AttenM_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21AttenD_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21ModFreqM_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21ModFreqD_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21ModDepthM_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21ModDepthD_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn21Carrier_Callback(hObject, eventdata, handles)
end
function pn21RippleM_Callback(hObject, eventdata, handles)
end
function pn21RippleD_Callback(hObject, eventdata, handles)
end
function pn21Components_Callback(hObject, eventdata, handles)
end
function pn21Ripple_Callback(hObject, eventdata, handles)
end
function pn21Semitones_Callback(hObject, eventdata, handles)
end
function pn21PhaseM_Callback(hObject, eventdata, handles)
end
function pn21PhaseD_Callback(hObject, eventdata, handles)
end
function pn21Phase_Callback(hObject, eventdata, handles)
end
function pn21AttenM_Callback(hObject, eventdata, handles)
end
function pn21AttenD_Callback(hObject, eventdata, handles)
end
function pn21ModFreq_Callback(hObject, eventdata, handles)
end
function pn21ModDepthM_Callback(hObject, eventdata, handles)
end
function pn21ModDepthD_Callback(hObject, eventdata, handles)
end
function pn21ModDepth_Callback(hObject, eventdata, handles)
end
function pn21ModZero_Callback(hObject, eventdata, handles)
end
function pn21Atten_Callback(hObject, eventdata, handles)
end
function pn21ModFreqM_Callback(hObject, eventdata, handles)
end
function pn21ModFreqD_Callback(hObject, eventdata, handles)
end
function pn21OK_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    if testDataPanel(hObject, 21) == 0
        set(data.pn21Apply,'Enable','on');
    else
        set(data.pn21Apply,'Enable','off');
    end
    guidata(hObject, data);
end
function pn21Cance1_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    setDataPanel(hObject,21);
    set(data.pn21Apply,'Enable','off');
    guidata(hObject, data);
end
function pn21Apply_Callback(hObject, eventdata, handles)
    if testDataPanel(hObject, 21) == 0
        getDataPanel(hObject,21);
    end
    data = guidata(hObject);
    set(data.pn21Apply,'Enable','off');
    guidata(hObject, data);
end
%=================================================================
% Options - Directories - Testing
%=================================================================
function tab31_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 31);
end
function tab32_Callback(hObject, eventdata, handles)
    setActivePanel(hObject, 32);
end
%------------------------ Directories ----------------------------
function pn31Home_Callback(hObject, eventdata, handles)
end
function pn31Home_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn31Config_Callback(hObject, eventdata, handles)
end
function pn31Config_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn31Data_Callback(hObject, eventdata, handles)
end
function pn31Data_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn31OK_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    if testDataPanel(hObject, 31) == 0
        set(data.pn31Apply,'Enable','on');
    else
        set(data.pn31Apply,'Enable','off');
    end
    guidata(hObject, data);
end
function pn31Cancel_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    setDataPanel(hObject,31);
    set(data.pn31Apply,'Enable','off');
    guidata(hObject, data);
end
function pn31Apply_Callback(hObject, eventdata, handles)
    getDataPanel(hObject,31);
    data = guidata(hObject);
    set(data.pn31Apply,'Enable','off');
    guidata(hObject, data);
end
%-------------------------- testing ------------------------------
% % function pn32Test_Callback(hObject, eventdata, handles)
% %     data = guidata(hObject);
% %     result = sendCMD(data, data.Globals.cmdTestLeds);
% % end
% % function pn32Red_Callback(hObject, eventdata, handles)
% %     data = guidata(hObject);
% %     if (get(data.pn32Red,'Value') == 0)
% %         set(data.pn32Green,'Value',1);  % set green
% %     else
% %         set(data.pn32Green,'Value',0);  % clear green
% %     end
% %     guidata(hObject, data);
% % end
% % function pn32Green_Callback(hObject, eventdata, handles)
% %     data = guidata(hObject);
% %     if (get(data.pn32Green,'Value') == 0)
% %         set(data.pn32Red,'Value',1);   
% %     else
% %         set(data.pn32Red,'Value',0);
% %     end
% %     guidata(hObject, data);
% % end
function pn31Ontime_Callback(hObject, eventdata, handles)
end
function pn31Ontime_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),... 
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
% % function pn30Intens_Callback(hObject, eventdata, handles)
% % end
% % function pn30Intens_CreateFcn(hObject, eventdata, handles)
% %     if ispc && isequal(get(hObject,'BackgroundColor'),...
% %         get(0,'defaultUicontrolBackgroundColor'))
% %         set(hObject,'BackgroundColor','white');
% %     end
% % end
%=================================================================
% The engine
%=================================================================
function TmrFcn(src,event,handles)
    data = guidata(handles);
%    drawnow();
%     if data.state == 200
%         ret = setupServer(data);
%         if ret == 0
%                 set(data.edClient,'String','Client Connected');
%                 set(data.edClient,'BackgroundColor',[0 1 0]);
%                 data.state = 0;
%         else
%                 set(data.edClient,'String','Error');
%                 set(data.edClient,'BackgroundColor',[1 0 0]);
%         end
%     end
%     if data.state == 0
%         result = sendCMD(data, data.Globals.cmdSetClock);
%         result = sendCMD(data, data.Globals.cmdGetClock);
%     end

%     dataRecord(1) = 2;
%     dataRecord(2) = data.cmdGetStatus;
%     result = mexServer(dataRecord);
%     if (result(3) == 0)
%         if data.currentTrial < data.numberOfTrials
%             data.currentTrial = data.currentTrial + 1;
%             nextTrial(handles);
%             str = sprintf('Trial %d(%d)',data.currentTrial,data.numberOfTrials);
%             set(data.trials_edit_info,'String',str);
%             pause(0.1);
%         else
%             stop(data.tmr);
%         end
%     end
    guidata(handles, data);
end
function result = sendCMD(data, cmd)
    switch cmd
        case data.Globals.cmdSetClock
            dataRecord(1) = 2;
            dataRecord(2) = cmd;
            result = mexServer(dataRecord);
        case data.Globals.cmdGetClock
            dataRecord(1) = 2;
            dataRecord(2) = cmd;
            result = mexServer(dataRecord);
        case data.Globals.cmdSetPIO
            dataRecord(1) = 3;
            dataRecord(2) = cmd;
            dataRecord(3) = data.outBits;
            result = mexServer(dataRecord);
        case data.Globals.cmdGetPIO
            dataRecord(1) = 2;
            dataRecord(2) = cmd;
            result = mexServer(dataRecord);
        case data.Globals.cmdTestLeds
            dataRecord(1) = 4; 
            dataRecord(2) = cmd;
            dataRecord(3) = data.save30.color;
            dataRecord(4) = data.save30.ontime;
            result = mexServer(dataRecord);
    end
end
%-----------------------------------------------------------------
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    data = guidata(hObject);
    stop(data.tmr);
    dataRecord(1) = 2;
    dataRecord(2) = data.Globals.TCPclose;
    result = mexServer(dataRecord);
    delete(hObject);
end
%-----------------------------------------------------------------
function pn32MaxIntens_Callback(hObject, eventdata, handles)
end
function pn32MaxIntens_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn32Red_Callback(hObject, eventdata, handles)
end
function pn32Green_Callback(hObject, eventdata, handles)
end
function pn32Ontime_Callback(hObject, eventdata, handles)
end
function pn32Ontime_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
function pn32TestLeds_Callback(hObject, eventdata, handles)
end
function pn32In0_Callback(hObject, eventdata, handles)
end
function pn32In1_Callback(hObject, eventdata, handles)
end
function pn32In2_Callback(hObject, eventdata, handles)
end
function pn32In3_Callback(hObject, eventdata, handles)
end
function pn32In4_Callback(hObject, eventdata, handles)
end
function pn32In5_Callback(hObject, eventdata, handles)
end
function pn32In6_Callback(hObject, eventdata, handles)
end
function pn32In7_Callback(hObject, eventdata, handles)
end
function pn32Out0_Callback(hObject, eventdata, handles)
end
function pn32Out1_Callback(hObject, eventdata, handles)
end
function pn32Out2_Callback(hObject, eventdata, handles)
end
function pn32Out3_Callback(hObject, eventdata, handles)
end
function pn32Out4_Callback(hObject, eventdata, handles)
end
function pn32Out5_Callback(hObject, eventdata, handles)
end
function pn32Out6_Callback(hObject, eventdata, handles)
end
function pn32Out7_Callback(hObject, eventdata, handles)
end
function pn32TestParallel_Callback(hObject, eventdata, handles)
    data = guidata(hObject);
    data.outBits = 0;
    data.outBits = bitset(data.outBits,1,get(data.pn32Out0,'Value'));
    data.outBits = bitset(data.outBits,2,get(data.pn32Out1,'Value'));
    data.outBits = bitset(data.outBits,3,get(data.pn32Out2,'Value'));
    data.outBits = bitset(data.outBits,4,get(data.pn32Out3,'Value'));
    data.outBits = bitset(data.outBits,5,get(data.pn32Out4,'Value'));
    data.outBits = bitset(data.outBits,6,get(data.pn32Out5,'Value'));
    data.outBits = bitset(data.outBits,7,get(data.pn32Out6,'Value'));
    data.outBits = bitset(data.outBits,8,get(data.pn32Out7,'Value'));
    result = sendCMD(data, data.Globals.cmdSetPIO);
    result = sendCMD(data, data.Globals.cmdGetPIO);
    data.inpBits = fix(result(3));
    set(data.pn32In0,'Value',bitget(data.inpBits,1));  % input bit 0
    set(data.pn32In1,'Value',bitget(data.inpBits,2));
    guidata(hObject, data);
end
function pn32LedIntens_Callback(hObject, eventdata, handles)
end
function pn32LedIntens_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
