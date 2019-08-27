# dingtalk

## 欄位

      t.string :access_token // 小程序token

      t.string :appkey // 小程序金鑰

      t.string :appsecret // 小程序秘鑰

      t.string :agent_id // 微應用代號



      t.string :sns_access_token // 登入sns的token 

      t.string :sns_app_id // 登入sns的app id

      t.string :sns_app_secret // 登入sns的密鑰



## 登入網址

    https://oapi.dingtalk.com/connect/oauth2/sns_authorize?appid=#{sns_app_id}&response_type=code&scope=snsapi_login&redirect_uri=#{redirect_uri}



#### 變數(範例)：

    { 
      appid: self.sns_app_id,
      response_type: "code",
      scope: "snsapi_login",
      redirect_uri: "http%3A%2F%2Flocalhost%3A3003%2Fapi%2Fv1%2Fdingtalk%2Fget"
    }


* redirect_uri 需要做Unicode字符轉換


#### 回傳：

`tmp_auth_code`



## API

###--獲取或更新Token--


**更新程序Token (7200秒後token會過期) **

    Dingtalk::Client.new(self).base.set_access_token



**更新登入sns的Token (7200秒後token會過期)**

    Dingtalk::Client.new(self).sns.set_access_token





### --身分认证对接--


**獲取persistent_code**

    Dingtalk::Client.new(self).sns.get_persistent_code(tmp_auth_code)

#### 回傳：

`“unionid”, “openid”, “persistent_code”`

* `tmp_auth_code`只能兌換一次


**獲取 sns_token**

    Dingtalk::Client.new(self).sns.get_sns_token(openid, persistent_code)

#### 回傳：

`sns_token`

* sns_token只能維持7200秒


**獲取User詳細資料**

    Dingtalk::Client.new(self).sns.get_user_info(sns_token)

#### 回傳：

`“nick”, “unionid”,  “dingId”, “openid”`





###--通讯录管理（成员与部门权限）--


**透過union_id獲取使用者**

    Dingtalk::Client.new(self).user.get_by_unionid(unionid)



**獲取使用者詳細資料**

    Dingtalk::Client.new(self).user.get(user_id)



**獲取部門成員資料**

    Dingtalk::Client.new(self).user.get_dept_member(department_id)



**獲取部門詳細資料**

    Dingtalk::Client.new(self).department.get(department_id)



**獲取部門列表**

    Dingtalk::Client.new(self).department.list



### --考勤--


**獲取打卡記錄**

    Dingtalk::Client.new(self).attendance.list_record(user_dingtalk_ids, start_time, end_time, is_i18n)



#### 變數：



    {

        user_dingtalk_ids: 要查詢的使用者叮叮的user_id,

        start_time: 查詢開始時間,

        end_time: 查詢結束時間,

        is_i18n: 是否'不'在中國大陸

    }



**獲取一段時間內請假多久**

    Dingtalk::Client.new(self).attendance.get_leave_approve_duration(user_dingtalk_id, from_date, to_date)





#### 變數：

	{
		“userid”: 要查詢的使用者叮叮的user_id,
		“from_date”: 查詢開始時間,
		“to_date”: 查詢結束時間
	}



**獲取特定日期的排班情況**

	Dingtalk::Client.new(self).topapi_attendance.listschedule(work_date.strftime(“%Y-%m-%d”))



**獲取考勤的群組**

	Dingtalk::Client.new(self).topapi_attendance.getsimplegroups



**獲取一些使用者在時間內的請假狀況**

	Dingtalk::Client.new(self).topapi_attendance.getleavestatus(params)



#### 變數：

    params = {

      “userid_list”: 要查詢的使用者們的叮叮的user_id,  ## "280059666324671328, manager2046"

      “start_time”: 查詢開始時間,  ## 1562167318000

      “end_time”: 查詢結束時間,  ## 1565850040000

      “offset”: offset, 0

      “size”: 查詢筆數最高為 ## 20

    }



### --应用管理--


**此应用哪些user可見**

	Dingtalk::Client.new(self).micro_app.visible_scopes(agent_id)



#### 變數：

	{agent_id: 微應用代號}



**微應用列表**

    Dingtalk::Client.new(self).micro_app.list



**更新微應用**

	Dingtalk::Client.new(self).micro_app.update_app_setting(agent_id, is_hidden, dept_visible_scopes)



#### 變數：

	{
	  "agentId": 微應用代號,
	  "isHidden": 是否隱藏,
	  "deptVisibleScopes": 可見的部門(Array)
	}


**使用者可以看到哪些微應用**

	Dingtalk::Client.new(self).micro_app.list_by_userid(user_id)



#### 變數：

	{"user_id": 要查詢的使用者的叮叮user_id}


### --消息推送--


**消息推送**

	Dingtalk::Client.new(self).message.send_working_message(message, dingtalk_user_ids)



#### 變數：

	{
	  "message": 推送訊息,
	  "dingtalk_user_ids": 推送的使用者 ## “user_1_id, user_2_id”
	}



### --审批--


**填寫一個審批表單**

	Dingtalk::Client.new(self).approve.processinstance_create(params)



#### 變數(以請假表單為例)：




	params = {
		“agent_id”: 微應用代號,
		“process_code”:  審批代號,  ## “PROC-79658E2D-52F0-418A-A272-D3212EA76333"
		“originator_user_id”:  審批發起人的叮叮user_id,
		“dept_id”: 部門id,
		“approvers”: 審批審批者ids, ## [“manager2146", “19394733257283"]
		“form_component_values”: 
		[
			{
            			“name”: “[\“Start Time\“,\“End Time\“]”,
            			“value”: [“2019-08-20 09:00”,“2019-08-20 12:00"],
           	 		“ext_value”: 3
			},
			{
				“name”: “请假类型“,
				“value”: “Sick leave”
			},
			{
				“name”: “Duration”,
				“value”: “生病請假”
			}
		]
	}

**分页获取审批实例單號**

    Dingtalk::Client.new(self).approve.get_processinstance_ids(params)



#### 變數：

    params = {
        "process_code": 審批代號, ## "PROC-79658E2D-52F0-418A-A272-D3212EA76333"
        "start_time": 開始時間, ##1563167318000
        "end_time": 結束時間, ##1565850040000
        "userid_list": 發起人叮叮id
    }




**獲取使用者可見之審批**

    Dingtalk::Client.new(self).approve.process_list_by_userid(params)



#### 變數：

    params = {
        "userid": 使用者叮叮id,
        "offset": 分頁號碼（從0開始）,
        "size": 顯示幾筆資料
    }


### 建立或更新一個審批(釘釘後台不可見)

    Dingtalk::Client.new(self).approve.save_process(params)



#### 變數：


    params = {
        "saveProcessRequest": {
            "agentid": 微應用代號,
            "process_code": 審批代號，如要建立新的則留空,
            "name": 審批名稱,
            "description": 審批敘述,
            "form_component_list":
                [
                    {
                        "component_name": "DDDateRangeField", // 一段時間內選取
                        "props": {
                            "id": "DDDateRangeField-00000000",
                            "label": ["开始时间小时","结束时间小时"],
                            "placeholder": "请选择日期及時間",
                            "required": true,
                            "unit": "小时"
                        }
                    },
                    {
                        "component_name": "TextField", // textfied填寫
                        "props": {
                            "id": "TextField-00000000",
                            "placeholder": "请输入1",
                            "label": "leave mode",
                            "required": true // 是否必填
                        }
                    }
                ]
            ,
            "fake_mode": true
        }
    }



**刪除一個審批**

    Dingtalk::Client.new(self).approve.delete_process(params)

#### 變數：

    params = {
        "request": {
            "agentid": 微應用代號,
            "process_code": 審批代號,
        }
    }
