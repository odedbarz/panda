#pragma once


// CSummary dialog

class CSummary : public CDialog
{
	DECLARE_DYNAMIC(CSummary)

public:
	CSummary(CWnd* pParent = NULL);   // standard constructor
	virtual ~CSummary();

// Dialog Data
	enum { IDD = IDD_SUMMARY };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
};
