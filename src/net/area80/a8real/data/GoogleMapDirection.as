package net.area80.a8real.data
{

	public class GoogleMapDirection
	{
		/*
		 * flash.displaySprite%com.google.maps.templates:XFEReplySwf
		url:String = "maps.googleapis.com";
		json:* = "
		{
			"name":"from: Bakersfield to: California",
			"Status":{"code":200,"request":"directions"},
			"Placemark":[
				{
					"id":"",
					"address":"Bakersfield, CA",
					"AddressDetails":{
						"Country":{
							"CountryNameCode":"US",
							"CountryName":"USA",
							"AdministrativeArea":{
								"AdministrativeAreaName":"CA",
								"SubAdministrativeArea":{
									"SubAdministrativeAreaName":"Kern",
									"Locality":{"LocalityName":"Bakersfield"}
								}
							}
						},
						"Accuracy": 4
					},
					"Point":{
						"coordinates":[-119.018712,35.373292,0]
					}
				},
				{
					"id":"",
					"address":"California",
					"AddressDetails":{
						"Country":{"CountryNameCode":"US","CountryName":"USA","AdministrativeArea":{"AdministrativeAreaName":"California"}},
						"Accuracy": 2
					},
					"Point":{"coordinates":[-119.417932,36.778261,0]}}],
					"Directions":{
						"copyrightsHtml":"Map data ¬©2012 Google",
						"summaryHtml":"113\u0026nbsp;mi (about 2 hours 14 mins)",
						"Distance":{"meters":181114,"html":"113\u0026nbsp;mi"},
						"Duration":{"seconds":8031,"html":"2 hours 14 mins"},
						"Routes":[
							{
								"Distance":{"meters":181114,"html":"113\u0026nbsp;mi"},
								"Duration":{"seconds":8031,"html":"2 hours 14 mins"},
								"summaryHtml":"113\u0026nbsp;mi (about 2 hours 14 mins)",
								"Steps":[
									{
										"descriptionHtml":"Head \u003Cb\u003Enorth\u003C\/b\u003E on \u003Cb\u003EChester Ave\u003C\/b\u003E toward \u003Cb\u003ETruxtun Ave\u003C\/b\u003E",
										"Distance":{"meters":853,"html":"0.5\u0026nbsp;mi"},
										"Duration":{"seconds":149,"html":"2 mins"},
										"Point":{"coordinates":[-119.018800,35.373290,0]},
										"polylineIndex":0
									},{
										"descriptionHtml":"Turn left onto \u003Cb\u003E24th St\u003C\/b\u003E",
										"Distance":{"meters":431,"html":"0.3\u0026nbsp;mi"},
										"Duration":{"seconds":30,"html":"30 secs"},
										"Point":{"coordinates":[-119.018770,35.380950,0]},
										"polylineIndex":5
									},{
										"descriptionHtml":"Turn right onto \u003Cb\u003EF St\u003C\/b\u003E",
										"Distance":{"meters":974,"html":"0.6\u0026nbsp;mi"},
										"Duration":{"seconds":81,"html":"1 min"},
										"Point":{"coordinates":[-119.023520,35.380970,0]},
										"polylineIndex":7
									},{
										"descriptionHtml":"Turn left onto \u003Cb\u003ECA-204 N\u003C\/b\u003E",
										"Distance":{"meters":2941,"html":"1.8\u0026nbsp;mi"},
										"Duration":{"seconds":179,"html":"3 mins"},
										"Point":{"coordinates":[-119.023030,35.389580,0]},
										"polylineIndex":12
									},{
										"descriptionHtml":"Merge onto \u003Cb\u003ECA-99 N\u003C\/b\u003E",
										"Distance":{"meters":135156,"html":"84.0\u0026nbsp;mi"},
										"Duration":{"seconds":4805,"html":"1 hour 20 mins"},
										"Point":{"coordinates":[-119.048000,35.406270,0]},
										"polylineIndex":21
									},{
										"descriptionHtml":"Take exit \u003Cb\u003E111\u003C\/b\u003E for \u003Cb\u003E18th Avenue\u003C\/b\u003E toward \u003Cb\u003EMendocino Ave\/\u003Cwbr\/\u003ERoad 12\u003C\/b\u003E",
										"Distance":{"meters":518,"html":"0.3\u0026nbsp;mi"},
										"Duration":{"seconds":38,"html":"38 secs"},
										"Point":{"coordinates":[-119.544170,36.504170,0]},
										"polylineIndex":373
									},{
										"descriptionHtml":"Turn right onto \u003Cb\u003E18th Ave\u003C\/b\u003E","Distance":{"meters":1157,"html":"0.7\u0026nbsp;mi"},"Duration":{"seconds":82,"html":"1 min"},"Point":{"coordinates":[-119.548160,36.507520,0]},"polylineIndex":378
									},{
										"descriptionHtml":"Turn right onto \u003Cb\u003ECA-201 E\/\u003Cwbr\/\u003ESierra St\u003C\/b\u003E\u003Cdiv class=\"\"\u003EContinue to follow CA-201 E\u003C\/div\u003E","Distance":{"meters":2390,"html":"1.5\u0026nbsp;mi"},"Duration":{"seconds":155,"html":"3 mins"},"Point":{"coordinates":[-119.547860,36.517910,0]},"polylineIndex":383
									},{
									"descriptionHtml":"Turn left onto \u003Cb\u003ERd 24\u003C\/b\u003E","Distance":{"meters":1469,"html":"0.9\u0026nbsp;mi"},"Duration":{"seconds":96,"html":"2 mins"},"Point":{"coordinates":[-119.521110,36.517870,0]},"polylineIndex":387
									},{
									"descriptionHtml":"Continue onto \u003Cb\u003ES Zediker Ave\u003C\/b\u003E","Distance":{"meters":8170,"html":"5.1\u0026nbsp;mi"},"Duration":{"seconds":550,"html":"9 mins"},"Point":{"coordinates":[-119.521140,36.531080,0]},"polylineIndex":389
									},{
									"descriptionHtml":"Turn right onto \u003Cb\u003EE Manning Ave\u003C\/b\u003E","Distance":{"meters":5382,"html":"3.3\u0026nbsp;mi"},"Duration":{"seconds":295,"html":"5 mins"},"Point":{"coordinates":[-119.520980,36.604560,0]},"polylineIndex":395
									},{
									"descriptionHtml":"Turn left onto \u003Cb\u003EW Manning Ave\u003C\/b\u003E","Distance":{"meters":439,"html":"0.3\u0026nbsp;mi"},"Duration":{"seconds":67,"html":"1 min"},"Point":{"coordinates":[-119.461300,36.601990,0]},"polylineIndex":406
									},{
									"descriptionHtml":"Turn left onto \u003Cb\u003EN Reed Ave\u003C\/b\u003E","Distance":{"meters":13107,"html":"8.1\u0026nbsp;mi"},"Duration":{"seconds":933,"html":"16 mins"},"Point":{"coordinates":[-119.457690,36.604140,0]},"polylineIndex":412
									},{
									"descriptionHtml":"Continue onto \u003Cb\u003ECA-180 W\/\u003Cwbr\/\u003EE Kings Canyon Rd\u003C\/b\u003E","Distance":{"meters":1175,"html":"0.7\u0026nbsp;mi"},"Duration":{"seconds":47,"html":"47 secs"},"Point":{"coordinates":[-119.457320,36.722010,0]},"polylineIndex":423
									},{
									"descriptionHtml":"Turn right onto \u003Cb\u003EN Piedra Rd\u003C\/b\u003E","Distance":{"meters":6042,"html":"3.8\u0026nbsp;mi"},"Duration":{"seconds":407,"html":"7 mins"},"Point":{"coordinates":[-119.466310,36.728920,0]},"polylineIndex":431
									},{
									"descriptionHtml":"Turn left onto \u003Cb\u003ETivy Valley Rd\u003C\/b\u003E","Distance":{"meters":829,"html":"0.5\u0026nbsp;mi"},"Duration":{"seconds":109,"html":"2 mins"},"Point":{"coordinates":[-119.419260,36.765500,0]},"polylineIndex":463
									},{
									"descriptionHtml":"\u003Cb\u003ETivy Valley Rd\u003C\/b\u003E turns slightly right and becomes \u003Cb\u003ETerrace Ave\u003C\/b\u003E","Distance":{"meters":81,"html":"266\u0026nbsp;ft"},"Duration":{"seconds":8,"html":"8 secs"},"Point":{"coordinates":[-119.418640,36.772910,0]},"polylineIndex":470
									}
								],
							"End":{
								"coordinates":[-119.417860,36.773150,0]
							},
							"polylineEndIndex":473
						}
					],
				"Polyline":{
					"id":"route",
					"points":"az{vEnzluU_ZBaBUcEGuJR??Ct\\??aWIuYJg@]y@eA??yUb\\ac@vn@cBzCaFvKsHxSeGvOyEvIsIfL??c`@dd@yC`D{AnBgBhBcK`M{BjByBzAcCpAkDrAaYbFgE|AmChBkAfAoEhFm@~@wB`FuDxKiBjEoBvD}BtD}ApB_HhHaLzImGhGkYd_@{I~LiDjDcEpF{CrFeCdG}CnJyBxHsArDkCdGmDnGeMbQuPbWqSbZwElGw`@dl@ipAzjBoLnPoH~Ku^vh@ocAfzAwKhOwHrHmH~HaDbFmBlDkI`Q{GpKuRnVm[j\\yH|GyJdI_JvGqTrNsIbFcKvEkHvC}D|@yLnBgCj@iH~BcH`DsFzC{ChA}Cz@aN~CsNdC}VjDun@jJqH|@qEZiPRmEZ{Fr@wGbBaIxCqEtAaDt@_vBh[}E`@gDJoLCgHWkA@mD^yDfAgCrA{AhAuArAuBlCgIbLgAdAyB|AoB~@cB`@{JdBu\\`FeD\\eDNkp@t@qDLoD\\}|C~c@qIzAaEhAiD~AmCz@mDbAwB\\eKfAwERaI?mGh@w}AxUkKrAwHtAuSpEou@|KwHt@gOfA_dD|d@aDn@_EjAuMnEwGtAkFh@uCJiKB_Jj@{gBfWyO~B_E~@ev@jVoPvFsG~AcsBdZkW|C_DFaE]gDu@oBs@aQyIcBs@}Bi@iASqBMuDDoAJiG|AiC|AoIlGgAn@sExA}dC~]wD^uDPmo@LyGd@wNpB{n@dJuDjA{CrAcPpJiFpBsEfA}zC`c@iGd@gGDkXkAcDCuGd@{XvDcj@~HaLdB{Cn@cIhDsRbJ_I|B}v@dLyRpD_q@nJsGd@_DDs]_AkHBeId@}IrBoDhA{a@fQgHtB_C`@}uBbZaCNaGGcGs@yBc@yIWeET_OlBwXbEuDx@wAd@eD|AiMhI{F|BaEt@mzA`T__AnMsHn@kNXaHn@cCb@wKzCmEbAmv@rKif@fIktBvYuHj@cFD_GOaJ_AeIOyFJiE\\en@rIaE`AmPnFid@fPcCr@qDp@i_AxM_r@jJoJ~@evDnOgu@dD_LlAidBh]gYnFsFv@mGf@sLFqJ_@{eAkM_ZyDeKcAsQw@c}ADgl@OkW?aLHgITkFb@cEd@}QzCmMxDmF|BiIbEyEpC{gFljDuHpDkN`FeGnCaG|DyMzKeWfPsf@tXusAfw@wIzDiN|EgGvCkD~BiDbDaBjByE|DkRfLyH`EgI|EoBz@aI`C_MfCmCr@sDlAqD|AiEbCoDjCaElDqG~HwCvEoEvIuEnH_G|GwArAiHbGoDdCeQnNmTvQumA~`AaJvIeEjDuEbDyC`BaG~BcElAyDp@}Gj@cMT_YbBuE|@wErAoEjBqG`DknBlhAw^fSsr@fa@sbCjuA_j@x[co@j^uj@b\\mNxH{OfKyJtJiX|YiCxBgBfAaFjCyDxA_Cp@qb@pIgE|AcGzC{q@x_@mFzDk[~Q{UzMoHpEsE~CoEpD_HrGw@|@uCvEmq@zrAaDfH}Mpa@kRve@cAzB_I|N_KvP??c@ZoFdHwGdHqBtD??wEAwD[yEQsl@K??A_TLks@Cy|A??qqAD??yhALswEJylB_@oXBo`@]??Ekz@Tiw@Ds`BJ_N@e[P}p@QuST{C|J}a@hAaE??kHyE{@sAo@oBU}A?uE??w[E}EHiT@}_C?kuAYgfDQm]QodDD}~AOgDG??mGHaBx@o@x@oHzN{HzJeA|BsGpS??aKQiASqAe@gBkAcLcJqBwBaJwL_UiUsDeEsAqCuCcKe@oA{AeCo@q@qDuB}RoI{CuB{AwAyCsEwCuG_I}RgAyDaHy[wAmEiUmf@wEeIoKsOgLiQcOeTk@cA_@mA??sDWgBYeAc@sASiEIiYG??]WO]AeB",
					"levels":"B???BBBB???BB?@???@?BB?????@????@??@?????@???@???@??????@?????????????????@??@????A?????????@??@???@???@@?????@??@????@??@?@???@@?????@???@???????@???@???@@????@?@??@???@???@????@?@???@@????@@???@?@??@??@??@????@????@@????@?@?@???@?@???@?????@?????@?@???@??A??@????@?@???@???@???A???@@??@??@?@??@??????@??????@???????@???????@???@??@???@???????@????@????@?????A????@@??@??BB???BB???BB??BBBB????BB??????@??BB?@??BB?????????BB??@?@?BB??@?@???@????@???@??@??@@?????BB?????BB??B",
					"numLevels":4,
					"zoomFactor":16
				}
			},
			"requestDomain":"creative-geeks.com/blog/wp-content/uploads/2009/09/GoogleDrivingDirections.swf"
			}
			*/

		public function GoogleMapDirection()
		{
		}
	}
}







