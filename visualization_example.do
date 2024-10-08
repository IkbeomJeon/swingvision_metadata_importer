clear
// 기존 프로그램이 정의되어 있다면 삭제하고, 오류를 무시
capture program drop extract_xyz

// 프로그램 정의 (프로그램이 이미 정의되어 있지 않다면 정의됨)
program define extract_xyz
    args varname shot_id
    gen `varname'_x = real(substr(`varname', 2, strpos(`varname', ",") - 2)) if sid == `shot_id'
    gen `varname'_temp = substr(`varname', strpos(`varname', ",") + 1, .) if sid == `shot_id'
    gen `varname'_y = real(substr(`varname'_temp, 1, strpos(`varname'_temp, ",") - 1)) if sid == `shot_id'
    gen `varname'_z = real(substr(`varname'_temp, strpos(`varname'_temp, ",") + 1, .)) if sid == `shot_id'
    drop `varname'_temp
end

import delimited "D:/swingvision_metadata_csv/matches_double/0a3b2297-c783-45c1-ba9e-eb36b4fa8151/shots.csv", varnames(1)

// 보려고하는 shot_idx 설정
local shot_idx = 85

extract_xyz bounce_location `shot_idx'
extract_xyz hit_location `shot_idx'

// 코트 사이즈 설정 (정식 테니스 코트 규정에 의한 코트 크기: width 10.97, length 23.77)
input x y
-5.485 0
5.485 0
5.485 23.77
-5.485 23.77
-5.485 0
end

twoway (line y x, lcolor(green)) || ///                 // 코트의 경계선 그리기
    (scatter hit_location_y hit_location_x, msymbol(Oh) msize(medium) mcolor(blue) ///
    legend(label(2 "hit_location"))) || ///				// 범례에 hit_location으로 표시
    (scatter bounce_location_y bounce_location_x, msymbol(Oh) msize(medium) mcolor(red) ///
    legend(label(3 "bounce_location"))) || /// 			// 범례에 bounce_location으로 표시
    , ///
    xscale(range(-6 6)) ///                             // x 축 범위를 -6 ~ 6으로 설정 (코트의 너비와 유사)
    yscale(range(0 25)) ///                             // y 축 범위를 0 ~ 25로 설정 (코트의 길이와 유사)
    xline(0, lcolor(green) lwidth(medium)) ///          // 코트의 중앙선 (x = 0, 코트 중심)
    yline(11.885, lcolor(green) lwidth(medium)) /// 	// 네트 선 (y = 11.885, y축의 중간)
    ylabel(0(1)25) ///
    xlabel(-6(1)6) ///
    title("Tennis Court") ///
    graphregion(margin(0 0 0 0) lcolor(none)) ///       // 그래프 여백 최소화 및 테두리 제거
    plotregion(margin(0 0 0 0)) ///                     // 플롯 영역 여백 최소화
    aspect(2.1668) ///                                  // 가로와 세로의 비율 설정 (10.97m / 23.77m)
    xsize(6) ///                                        // 그래프의 가로 크기 확대
    ysize(6) ///                                        // 그래프의 세로 크기 확대
    legend(order(2 "hit_location" 3 "bounce_location") label(1 "Court Boundary") ) // 범례 순서와 위치 설정
