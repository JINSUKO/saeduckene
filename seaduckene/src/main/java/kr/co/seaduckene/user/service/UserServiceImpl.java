package kr.co.seaduckene.user.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.util.WebUtils;

import kr.co.seaduckene.admin.mapper.IAdminMapper;
import kr.co.seaduckene.common.AddressVO;
import kr.co.seaduckene.common.CategoryVO;
import kr.co.seaduckene.common.IAddressMapper;
import kr.co.seaduckene.favorite.FavoriteVO;
import kr.co.seaduckene.product.command.ProductBasketVO;
import kr.co.seaduckene.product.mapper.IProductMapper;
import kr.co.seaduckene.user.command.Categories;
import kr.co.seaduckene.user.command.UserVO;
import kr.co.seaduckene.user.mapper.IUserMapper;
import kr.co.seaduckene.util.AskCategoryBoardVO;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class UserServiceImpl implements IUserService {
	
	@Autowired
	private IUserMapper userMapper;
	
	@Autowired
	private IAddressMapper addressMapper;
	
	@Autowired
	private IProductMapper productMapper;
	
	@Autowired
	private IAdminMapper adminMapper;

	@Override
	public void registUser(UserVO userVO) {
		userMapper.registUser(userVO);
	}
	
	@Override
	public void registKKLAcc(UserVO userVO) {
		userMapper.registKKLAcc(userVO);
	}
	
	@Override
	public void updateKKLAccToken(UserVO userVO) {
		userMapper.updateKKLAccToken(userVO);
	}
	
	@Override
	public boolean checkKKL(String KKLId) {
		return userMapper.checkKKL(KKLId) == 0 ? false : true;
	}
	
	@Override
	public void registNVLAcc(UserVO userVO) {
		userMapper.registNVLAcc(userVO);
	}
	
	@Override
	public void updateNVLAccToken(UserVO userVO) {
		userMapper.updateNVLAccToken(userVO);
	}
	
	@Override
	public boolean checkNL(String NVLId) {
		return userMapper.checkNL(NVLId) == 0 ? false : true;
	}
	
	@Override
	public UserVO getUserVoWithKKLId(String KKLId) {
		return userMapper.getUserVoWithKKLId(KKLId);
	}
	
	@Override
	public UserVO getUserVoWithNVLId(String NVLId) {
		return userMapper.getUserVoWithNVLId(NVLId);
	}
	
	@Override
	public UserVO getUserVoWithNo(int userNo) {
		return userMapper.getUserVoWithNo(userNo);
	}
	
	@Override
	public UserVO getUserVo(UserVO userVO) {
		return userMapper.getUserVo(userVO);
	}

	@Override
	public List<Categories> getCategories() {
		return userMapper.getCategories();
	}
	
	@Override
	public void addUserFavorites(String[] categoryMajorTitles, String[] categoryMinorTitles, int userNo) {
		
		for (int i = 0; i < categoryMajorTitles.length; i++) {
			CategoryVO categoryVo = new CategoryVO(0, categoryMajorTitles[i], categoryMinorTitles[i], null);
			Map<String, Integer> map = new HashMap<String, Integer>();
			map.put("categoryNo", userMapper.getCategoryNo(categoryVo));
			map.put("userNo", userNo);
			
			userMapper.insertFavorite(map);
		}
		
	}
	
	@Override
	public String registAddr(AddressVO addressVO) {
		
		addressVO.setAddressRepresentative(1);
		
		addressMapper.addAddress(addressVO);
		/* addressMapper.addAddress(addressVO, userNo); */
		return "success";
		
	}
	
	@Override
	public void updateAddr(AddressVO addressVO) {
		
		addressMapper.updateAddr(addressVO);
	}
	
	@Override
	public List<ProductBasketVO> getBasket(int num) {
		return userMapper.getBasket(num);
	}

	@Override
	public int checkId(String userId) {
		return userMapper.checkId(userId);
	}
	
	@Override
	public int checkNickname(String userNickname) {
		return userMapper.checkNickname(userNickname);
	}
	
	@Override
	public List<CategoryVO> getUserCategories(int userNo) {
		
		return userMapper.getUserCategories(userNo);
	}
	
	@Override
	public List<AddressVO> getUserAddr(int userNo) {
		return addressMapper.getUserAddr(userNo);
	}
	
	@Override
	public List<String> findAccount (String userName, String userEmail) {
		log.info(userEmail);
		log.info(userName);
		
		Map<String, Object> map = new HashMap<>();
		map.put("userName", userName);
		map.put("userEmail", userEmail);
		
		List<String> userIds = userMapper.findAccount(map);
		log.info(userIds);
		
		return userIds;
	}

	@Override
	public void updatePw(String userId, String tmpPw) {
		Map<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("tmpPw", tmpPw);
		
		userMapper.updatePw(map);
		
	}
	
	@Override
	public void setAutoLogin(UserVO userVo) {
		userMapper.setAutoLogin(userVo);
	}
	
	@Override
	public UserVO getUserBySessionId(String sessionId) {
		return userMapper.getUserBySessionId(sessionId);
	}
	
	@Override
	public void undoAutoLogin(int userNo) {
		userMapper.undoAutoLogin(userNo);
	}
	
	@Override
	public int checkCurrPw(Map<String, String> pwkMap) {
		return userMapper.checkCurrPw(pwkMap);
	}
	
	@Override
	public void changePw(Map<String, String> pwkMap) {
		userMapper.changePw(pwkMap);
	}
	
	@Override
	public void updateUserInfo(UserVO userVo) {
		userMapper.updateUserInfo(userVo);
	}

	@Override
	public List<FavoriteVO> getUserFavorites(int userNo) {
		return userMapper.getUserFavorites(userNo);
	}
	
	@Override
	public void deleteUserFavorites(Map<String, Object> deletedCount) {
		userMapper.deleteUserFavorites(deletedCount);
	}
	
	@Override
	public void updateUserFavorites(String[] newMajorArray, String[] newMinorArray, int userNo) {
		
		List<CategoryVO> currCategoryVOs = userMapper.getUserCategories(userNo);
		List<FavoriteVO> currFavoriteVOs = userMapper.getUserFavorites(userNo);
		
		for (int i = 0; i < currCategoryVOs.size(); i++) {
			CategoryVO categoryVo = new CategoryVO(0, newMajorArray[i], newMinorArray[i], null);
			Map<String, Integer> map = new HashMap<String, Integer>();
			if (currCategoryVOs.size() != 0 && currCategoryVOs.get(i).getCategoryNo() != userMapper.getCategoryNo(categoryVo)) {
				log.info("curr: " + currCategoryVOs.get(i).getCategoryNo());
				log.info("new: " + userMapper.getCategoryNo(categoryVo));
				map.put("categoryNo", userMapper.getCategoryNo(categoryVo));
				map.put("userNo", userNo);
				log.info("currFavNo: " + currFavoriteVOs.get(i).getFavoriteNo());
				map.put("favoriteNo", currFavoriteVOs.get(i).getFavoriteNo());
				
				userMapper.updateUserFavorites(map);
			}
		}
		
	}
	
	@Override
	public void addNewAddress(String[] addressBasicArray, String[] addressDetailArray, String[] addressZipNumArray, int userNo) {
		
		log.info(addressBasicArray);
		log.info(addressDetailArray);
		log.info(addressZipNumArray);
		
		AddressVO addrVo = null;
		
		for (int i = 0; i < addressBasicArray.length; i++) {
			
			if (addressMapper.getUserAddr(userNo).size() == 0 && i == 0) {				
				addrVo = new AddressVO(0, addressDetailArray[i], addressBasicArray[i], addressZipNumArray[i], 1, userNo);
			} else {
				addrVo = new AddressVO(0, addressDetailArray[i], addressBasicArray[i], addressZipNumArray[i], 0, userNo);
			}
			
			log.info(addrVo);
			addressMapper.addNewAddress(addrVo);
		}
		
	}
	
	@Override
	public void deleteUserAddress(Map<String, Object> deletedCount) {
		addressMapper.deleteUserAddress(deletedCount);
	}
	
	@Override
	public void updateUserAddress(String[] newAddressBasicArray, String[] newAddressDetailArray, String[] newAddressZipNumArray, int userNo) {
		
		log.info(newAddressBasicArray);
		log.info(newAddressDetailArray);
		log.info(newAddressZipNumArray);
		
		List<AddressVO> currAddressVOs = addressMapper.getUserAddr(userNo);
		
		for (int i = 0; i < newAddressBasicArray.length; i++) {
			if (!currAddressVOs.get(i).getAddressBasic().equals(newAddressBasicArray[i])
				|| !currAddressVOs.get(i).getAddressDetail().trim().equals(newAddressDetailArray[i].trim())
				|| !currAddressVOs.get(i).getAddressZipNum().equals(newAddressZipNumArray[i])) {

				AddressVO modiAddressVo = new AddressVO(currAddressVOs.get(i).getAddressNo(), newAddressDetailArray[i], newAddressBasicArray[i], newAddressZipNumArray[i], 0, userNo);
				
				log.info(modiAddressVo);
				
				addressMapper.updateAddr(modiAddressVo);
			}
		}
	}

	@Override
	public int getCountUserAddress(int userNo) {
		return userMapper.getCountUserAddress(userNo);
	}
	
	@Override
	public AddressVO getUserAddressWithRn(int addressIndex, int userNo) {
		
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("addressRn", addressIndex);
		map.put("userNo", userNo);
		
		return addressMapper.getUserAddressWithRn(map);
	}
	
	@Override
	public void modiAddressNoAndRepresent(Map<String, Integer> map) {
		addressMapper.modiAddressNoAndRepresent(map);
	}
	
	@Override
	public void deleteUserAllInfo(int userNo, HttpServletRequest request, HttpServletResponse response) {
		userMapper.deleteUserAllInfoUser(userNo);
		userMapper.deleteUserAllInfofavorite(userNo);
		addressMapper.deleteUserAllInfo(userNo);
		productMapper.deleteUserAllInfoOrder(userNo);
		productMapper.deleteUserAllInfoBasket(userNo);
		
		HttpSession session = request.getSession();
		
		Cookie autoLoginCookie = WebUtils.getCookie(request, "autoLoginCookie");
		if (autoLoginCookie != null) {
			UserVO userVo = userMapper.getUserBySessionId(autoLoginCookie.getValue());
			log.info("autoLogin userVo: " + userVo);
			
			if (userVo != null) {
				// 쿠키 삭제는 받아온 쿠키 객체를 직접 지운다
				autoLoginCookie.setPath(request.getContextPath() + "/");
				autoLoginCookie.setMaxAge(0);
				response.addCookie(autoLoginCookie);
				userMapper.undoAutoLogin(userVo.getUserNo());
			}
			
		}
		
		if (session.getAttribute("login") != null) {
			session.removeAttribute("login");
		}
	}
	
	
	@Override
	public int checkUser(String userId, String userEmail) {
		Map<String, Object> map =  new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("userEmail", userEmail);
				
		return userMapper.checkUser(map);
	}
	
	@Override
	public List<AskCategoryBoardVO> getUserAskCategoryBoardList(int userNo) {
		return adminMapper.getUserAskCategoryBoardList(userNo);
	}
	
	@Override
	public AskCategoryBoardVO getAskCategoryBoard(int askBoardNo) {
		return adminMapper.getAskCategoryBoard(askBoardNo);
	}


}
