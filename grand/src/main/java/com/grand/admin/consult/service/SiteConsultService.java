package com.grand.admin.consult.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.grand.admin.consult.vo.SiteConsultVO;


public interface SiteConsultService {
	
	public List<SiteConsultVO> selectSiteConsultList(SiteConsultVO vo) throws Exception;
	
	public int selectSiteConsultCount(SiteConsultVO vo) throws Exception;
	
	public int updateSiteConsult(SiteConsultVO vo) throws Exception;
	
	public SiteConsultVO selectSiteConsult(SiteConsultVO vo) throws Exception;

	public void updateSiteConsultGrid(SiteConsultVO vo,HttpServletRequest req) throws Exception;
	
}
