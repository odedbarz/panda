// AcousticNoise.cpp : implementation file
//

#include "stdafx.h"
#include "trainen.h"
#include "AcousticNoise.h"


// AcousticNoise dialog

IMPLEMENT_DYNAMIC(CAcousticNoise, CDialog)

CAcousticNoise::CAcousticNoise(CWnd* pParent /*=NULL*/)
	: CDialog(CAcousticNoise::IDD, pParent)
	, m_Atten(_T(""))	
	, m_Attend(_T(""))
	, m_ModF(_T(""))
	, m_ModFd(_T(""))
	, m_ModD(_T(""))
	, m_ModDd(_T(""))
{
}

CAcousticNoise::~CAcousticNoise()
{
}

void CAcousticNoise::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDCANCEL, Cancel);
	DDX_Control(pDX, IDC_BUTTON2, Apply);
	DDX_Control(pDX, IDOK, Hide);
	DDX_Text(pDX, IDC_EDIT5,  m_Atten);	
	DDX_Text(pDX, IDC_EDIT11, m_Attend);
	DDX_Text(pDX, IDC_EDIT9,  m_ModF);
	DDX_Text(pDX, IDC_EDIT12, m_ModFd);
	DDX_Text(pDX, IDC_EDIT1,  m_ModD);
	DDX_Text(pDX, IDC_EDIT2,  m_ModDd);
	DDX_Control(pDX, IDC_SPIN4,  s_Atten);	
	DDX_Control(pDX, IDC_SPIN6,  s_Attend);
	DDX_Control(pDX, IDC_SPIN10, s_ModF);
	DDX_Control(pDX, IDC_SPIN13, s_ModFd);
	DDX_Control(pDX, IDC_SPIN1,  s_ModD);
	DDX_Control(pDX, IDC_SPIN2,  s_ModDd);
	DDX_Control(pDX, IDC_CHECK6,  v_Attenv);
	DDX_Control(pDX, IDC_CHECK11, v_ModFv);
	DDX_Control(pDX, IDC_CHECK12, v_ModFz);
	DDX_Control(pDX, IDC_CHECK1,  v_ModDv);
}


BEGIN_MESSAGE_MAP(CAcousticNoise, CDialog)
	ON_NOTIFY(UDN_DELTAPOS, IDC_SPIN4, &CAcousticNoise::OnDeltaposSpin4)
	ON_NOTIFY(UDN_DELTAPOS, IDC_SPIN10, &CAcousticNoise::OnDeltaposSpin10)
	ON_NOTIFY(UDN_DELTAPOS, IDC_SPIN1, &CAcousticNoise::OnDeltaposSpin1)
	ON_NOTIFY(UDN_DELTAPOS, IDC_SPIN6, &CAcousticNoise::OnDeltaposSpin6)
	ON_NOTIFY(UDN_DELTAPOS, IDC_SPIN13, &CAcousticNoise::OnDeltaposSpin13)
	ON_NOTIFY(UDN_DELTAPOS, IDC_SPIN2, &CAcousticNoise::OnDeltaposSpin2)
	ON_BN_CLICKED(IDOK, &CAcousticNoise::OnBnClickedOk)
	ON_BN_CLICKED(IDCANCEL, &CAcousticNoise::OnBnClickedCancel)
	ON_BN_CLICKED(IDC_BUTTON2, &CAcousticNoise::OnBnClickedButton2)
	ON_BN_CLICKED(IDC_CHECK6, &CAcousticNoise::setApplyGreen)
	ON_BN_CLICKED(IDC_CHECK11, &CAcousticNoise::setApplyGreen)
	ON_BN_CLICKED(IDC_CHECK12, &CAcousticNoise::setApplyGreen)
	ON_BN_CLICKED(IDC_CHECK1, &CAcousticNoise::setApplyGreen)
END_MESSAGE_MAP()

BOOL CAcousticNoise::OnInitDialog()
{
	CDialog::OnInitDialog();

	loadData();
	UpdateData(false);
	Cancel.SetColor(RGB(200,200,200)); // gray
	Apply.SetColor(RGB(200,200,200)); // gray
	Hide.SetColor(RGB(200,200,200)); // gray
	return TRUE;
}
void CAcousticNoise::saveData(void)
{
	CtrainenApp *pnt = (CtrainenApp *) AfxGetApp()->m_pMainWnd;
	pnt->getSettings()->Acoustic2.Atten =
					s_Atten.GetPos() & 0xFFFF;
	pnt->getSettings()->Acoustic2.Attend =
					s_Attend.GetPos() & 0xFFFF;
	pnt->getSettings()->Acoustic2.Attenv =
					(v_Attenv.GetCheck() == 1);
	pnt->getSettings()->Acoustic2.ModF =
					s_ModF.GetPos() & 0xFFFF;
	pnt->getSettings()->Acoustic2.ModFd =
					s_ModFd.GetPos() & 0xFFFF;
	pnt->getSettings()->Acoustic2.ModFv =
					(v_ModFv.GetCheck() == 1);
	pnt->getSettings()->Acoustic2.ModFz =
					(v_ModFz.GetCheck() == 1);
	pnt->getSettings()->Acoustic2.ModD =
					s_ModD.GetPos() & 0xFFFF;
	pnt->getSettings()->Acoustic2.ModDd =
					s_ModDd.GetPos() & 0xFFFF;
	pnt->getSettings()->Acoustic2.ModDv =
					(v_ModDv.GetCheck() ==1);
}
void CAcousticNoise::loadData(void)
{
	CtrainenApp *pnt = (CtrainenApp *) AfxGetApp()->m_pMainWnd;
	int n;
	bool b;
	// Attenuation
	n = pnt->getSettings()->Acoustic2.Atten;
	s_Atten.SetRange(10,100); 
	s_Atten.SetPos(n); m_Atten.Format("%d",n);
	n = pnt->getSettings()->Acoustic2.Attend;
	s_Attend.SetRange(0,10); 
	s_Attend.SetPos(n); m_Attend.Format("%d",n);
	b = pnt->getSettings()->Acoustic2.Attenv;
	v_Attenv.SetCheck(b);
	// Modulation frequency
	n = pnt->getSettings()->Acoustic2.ModF;
	s_ModF.SetRange(10,100); 
	s_ModF.SetPos(n); m_ModF.Format("%d",n);
	n = pnt->getSettings()->Acoustic2.ModFd;
	s_ModFd.SetRange(0,100); 
	s_ModFd.SetPos(n); m_ModFd.Format("%d",n);
	b = pnt->getSettings()->Acoustic2.ModFv;
	v_ModFv.SetCheck(b);
	b = pnt->getSettings()->Acoustic2.ModFz;
	v_ModFz.SetCheck(b);
	// Modulation depth
	n = pnt->getSettings()->Acoustic2.ModD;
	s_ModD.SetRange(0,100); 
	s_ModD.SetPos(n); m_ModD.Format("%d",n);
	n = pnt->getSettings()->Acoustic2.ModDd;
	s_ModDd.SetRange(0,10); 
	s_ModDd.SetPos(n); m_ModDd.Format("%d",n);
	b = pnt->getSettings()->Acoustic2.ModDv;
	v_ModDv.SetCheck(b);
}

// CAcousticNoise message handlers
void CAcousticNoise::OnDeltaposSpin4(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMUPDOWN pNMUpDown = reinterpret_cast<LPNMUPDOWN>(pNMHDR);

	int Low, High, nPos;
	s_Atten.GetRange(Low, High);
	nPos  = pNMUpDown->iPos;
	nPos += pNMUpDown->iDelta;

	if ((nPos <= High) && (nPos >= Low))
	{
		m_Atten.Format("%d",nPos);
		UpdateData(false);
		*pResult = 0;
	} else *pResult = 1;
	setApplyGreen();
}
void CAcousticNoise::OnDeltaposSpin10(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMUPDOWN pNMUpDown = reinterpret_cast<LPNMUPDOWN>(pNMHDR);

	int Low, High, nPos;
	s_ModF.GetRange(Low, High);
	nPos  = pNMUpDown->iPos;
	nPos += pNMUpDown->iDelta;

	if ((nPos <= High) && (nPos >= Low))
	{
		m_ModF.Format("%d",nPos);
		UpdateData(false);
		*pResult = 0;
	} else *pResult = 1;
	setApplyGreen();
}
void CAcousticNoise::OnDeltaposSpin1(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMUPDOWN pNMUpDown = reinterpret_cast<LPNMUPDOWN>(pNMHDR);

	int Low, High, nPos;
	s_ModD.GetRange(Low, High);
	nPos  = pNMUpDown->iPos;
	nPos += pNMUpDown->iDelta;

	if ((nPos <= High) && (nPos >= Low))
	{
		m_ModD.Format("%d",nPos);
		UpdateData(false);
		*pResult = 0;
	} else *pResult = 1;
	setApplyGreen();
}
void CAcousticNoise::OnDeltaposSpin6(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMUPDOWN pNMUpDown = reinterpret_cast<LPNMUPDOWN>(pNMHDR);

	int Low, High, nPos;
	s_Attend.GetRange(Low, High);
	nPos  = pNMUpDown->iPos;
	nPos += pNMUpDown->iDelta;

	if ((nPos <= High) && (nPos >= Low))
	{
		m_Attend.Format("%d",nPos);
		UpdateData(false);
		*pResult = 0;
	} else *pResult = 1;
	setApplyGreen();
}
void CAcousticNoise::OnDeltaposSpin13(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMUPDOWN pNMUpDown = reinterpret_cast<LPNMUPDOWN>(pNMHDR);

	int Low, High, nPos;
	s_ModFd.GetRange(Low, High);
	nPos  = pNMUpDown->iPos;
	nPos += pNMUpDown->iDelta;

	if ((nPos <= High) && (nPos >= Low))
	{
		m_ModFd.Format("%d",nPos);
		UpdateData(false);
		*pResult = 0;
	} else *pResult = 1;
	setApplyGreen();
}
void CAcousticNoise::OnDeltaposSpin2(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMUPDOWN pNMUpDown = reinterpret_cast<LPNMUPDOWN>(pNMHDR);

	int Low, High, nPos;
	s_ModDd.GetRange(Low, High);
	nPos  = pNMUpDown->iPos;
	nPos += pNMUpDown->iDelta;

	if ((nPos <= High) && (nPos >= Low))
	{
		m_ModDd.Format("%d",nPos);
		UpdateData(false);
		*pResult = 0;
	} else *pResult = 1;
	setApplyGreen();
}
// cancel
void CAcousticNoise::OnBnClickedCancel()
{
	loadData();
	UpdateData(false);
	setApplyGray();
}
// apply
void CAcousticNoise::OnBnClickedButton2()
{
	saveData();
	setApplyGray();
}
// close
void CAcousticNoise::OnBnClickedOk()
{
	ShowWindow(SW_HIDE);
}
void CAcousticNoise::setApplyGreen()
{
	Apply.SetColor(RGB(0,200,0));
}
void CAcousticNoise::setApplyGray()
{
	Apply.SetColor(RGB(200,200,200));
}
