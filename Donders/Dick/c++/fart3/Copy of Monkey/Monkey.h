// Monkey.h : main header file for the Monkey application
//
#pragma once

// #define _HARDWARE

#include <globals.h>

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"       // main symbols


// CMonkeyApp:
// See Monkey.cpp for the implementation of this class
//
typedef struct
{
	int phase;
	bool init;
	int ring;
	int spoke;
	int nStim;

	int modFreq;
	int mod;
	int freq;
	int atten;
	int density;
	int sndType;

	int fix[5];  	// ring,spoke,color,intensity,onTime
	int tar[5];
	int dim[5];
}SaveSound_Record;

typedef struct
{
	double velocity;	// modulation frequency
	double density;		// Ripple frequency (cyc/oct)
	double modulation;	// modulation depth
	double durStat;		// Duration static, target fixed+random
	double durRipple;	// Duration ripple, target changed
	double F0;			// Carrier frequency
	double fFreq;		// Mumber of components
	double PhiF0;		// Ripple phase at F0
	double rate;		// Sample rate
}Ripple_Record;

class CMonkeyApp : public CWinApp
{
public:
	CMonkeyApp();


// Overrides
public:
	virtual BOOL InitInstance();

// Implementation
	afx_msg void OnAppAbout();
	DECLARE_MESSAGE_MAP()

public:
	void SetMenuItem(int ID, bool enable);
	void MarkMenuItem(int ID, bool mark);

	CString	charTOstr(int n,  char *p);
	void	strTOchar(CString str, char *p, int max);

	void setTrialStatus(int status);
	int  getTrialStatus();

	void redrawAll(void);

	void OnAppExit();
	void SaveInitialParameters(FILE *pFile);
	void SaveOutputHeader(CString fileName);
	void SaveOutputParameters(CString FileName, int index);
	void SaveOutputData(CString FileName);
	Stims_Record *getStimRecord(int index);
	void NextTrial(void);
	void loadSound_ripple(int tar, int dim);
	void restart_ripple(int tar, int dim);
	void loadSound_noise(int tar, int dim, int modFreq, int mod);
	void loadSound_tone(int tar, int dim, int modFreq, int mod, int freq);
	void loadSound_noSound();

	Settings_Record *getSettings(void);
	int  *getDataRecord(void);
	int  *getFSMcmd(void);
	float *getSND(void);
	int   *getnTot(void);
	void  setnTot(int n);
	Ripple_Record *getRippleRecord(void);
public:
	int g_barLevel;
	int g_barTime;
	int g_trialStatus;
	
public:
	int *getGreenLeds();
	int *getRedLeds();
	int *getParInp();
public:
	void OnTimer(UINT nTimer);
	void setClock();
	void getFrequency();
	int  getClock();

public:
	afx_msg void OnParametersettingTiming();
	afx_msg void OnParametersettingLeds();
	afx_msg void OnParametersettingReward();
	afx_msg void OnAcousticstimuliStimulustype();
	afx_msg void OnAcousticstimuliTone();
	afx_msg void OnAcousticstimuliNoise();
	afx_msg void OnAcousticstimuliRipple();
	afx_msg void OnAcousticstimuliNosound();
	afx_msg void OnTest();
	afx_msg void OnStart();
	afx_msg void OnStop();
	afx_msg void OnExit();
};

extern CMonkeyApp theApp;