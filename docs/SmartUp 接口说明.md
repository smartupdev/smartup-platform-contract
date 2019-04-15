## SmartUp 接口说明

#### 关于samrtUp

````
1. smartUp 为 smartUp 平台的主要合约，主要功能有创建CT市场，标记CT市场，申诉CT市场，查询CT市场；
2. smartUp 的选举陪审团的方式为随机选举，当选举到的人已经是陪审团成员或者是标记市场的人时跳过，选取他的下一个地址为陪审团；
````

#### smartUp平台的参数设置

```
uint8 constant MINIMUM_BALLOTS = 1;  最少投票为1票才能有效
string constant CREATE_MARKET_NTT_KEY = "create_market"； 创建市场的key

ISmartIdeaToken constant SUT = ISmartIdeaToken(0x5eCaA8DA2210bB422b9fBb620d4e67Aa83480e1d); SUT地址
IGradeable constant NTT = IGradeable(0x4Cb5377cAf6a466Bf78a0eCbBe462b4B793E561F)； NTT地址； 

uint8 constant CREATE_MARKET_ACTION = 1； 创建市场接受的参数为1；
uint8 constant FLAG_MARKET_ACTION = 2;   标记市场接受的参数为2；
uint8 constant APPEAL_MARKET_ACTION = 3;  申诉市场的接受参数为3；

uint256 constant MINIMUM_FLAGGING_DEPOSIT = 100 * (10 ** 18); 最少标记市场所需 SUT 100 个；
uint256 constant FLAGGING_DEPOSIT_REQUIRED = 2500 * (10 ** 18); 标记市场成功一共需要 SUT 2500 个；
uint256 constant APPEALING_DEPOSIT_REQUIRED = 2500 * (10 ** 18); 申诉市场所需 SUT 2500 个；
uint256 constant CREATE_MARKET_DEPOSIT_REQUIRED = 2500 * (10 ** 18); 创建市场所需 SUT 2500 个；

uint256 constant JUROR_COUNT = 3; 陪审团数量为 3 个；

uint256 constant PROTECTION_PERIOD = 90 seconds;  创建市场后的保护时间；
uint256 constant VOTING_PERIOD = 3 minutes;  陪审团投票时间段；
uint256 constant FLAGGING_PERIOD = 3 minutes;  标记市场有效时间段；
uint256 constant APPEALING_PERIOD = 3 minutes;  申诉市场有效时间段；
```

#### 接受操作市场指令

```
function receiveApproval(address sutOwner, uint256 approvedSutAmount, address token, bytes calldata extraData) external
参数说明：
address sutOwner  要操作市场的地址；
uint256 approvedSutAmount  允许转出的SUT数目；
address token  SUT 地址；
bytes calldata extraData； 包含操作市场的指令； 1结尾创建市场，2 结尾标记市场， 3 结尾申诉市场；

事件：
1.当为创建市场时：
Transfer(from, to, value)；
MarketCreated(ctAddress, marketCreator, initialDeposit);

2.当为标记市场时：
Transfer(from, to, value);
Flagging(ctAddress, flagger, depositAmount, marketData.flaggerDeposit);

3.当为申诉市场时：
Transfer(from, to, value);
AppealMarket( ctAddress,  appealer,  depositAmount);
```

#### 标记市场未达到最少标记资金并超时时撤销标记

```
function closeFlagging(address ctAddress) external
参数说明：
address ctAddress CT市场地址；

事件：
CloseFlagging(ctAddress, msg.sender);
```

#### 投票

```
function vote(address ctAddress, bool dissolve) external
参数说明：
address ctAddress CT市场地址；
bool dissolve   true 同意解散市场， false 不同意解散市场；

事件：
MakeVote (ctAddress, msg.sender, marketData.appealRound, dissolve);
```

#### 对投票结果进行判断并进行下一步操作

````
function conclude(address ctAddress) external
参数说明：
address ctAddress CT市场地址；
````

#### 解散市场

````
function dissolve(address ctAddress) external
参数说明：
address ctAddress CT市场地址；
````

#### 查看CT市场的市场创建者

```
function creator(address ctAddress) external view returns (address)
参数说明：
address ctAddress CT市场地址；

返回值
address  市场创建者地址；
```

#### 查看CT市场的市场状态

```
function state(address ctAddress) external view returns (State)
参数说明：
address ctAddress CT市场地址；

返回值：
State   市场状态；
```

#### 查看CT市场的标记市场人数

```
function flaggerSize(address ctAddress) external view returns (uint256)
参数说明：
address ctAddress CT市场地址；

返回值：
uint256 标记人数；
```

#### 查看CT市场的标记市场的地址

```
function flaggerList(address ctAddress) external view returns (address[] memory)
参数说明：
address ctAddress CT市场地址；

返回值：
address[] memory；  标记市场的地址数组；
```

#### 查看CT市场的标记市场地址的SUT押金

```
function flaggerDeposits(address ctAddress) external view returns (uint256[] memory)
参数说明：
address ctAddress CT市场地址；

返回值：
uint256[] memory；  标记市场的地址押金详情；
```

#### 查看CT市场的陪审团人数

```
function jurorSize(address ctAddress) external view returns (uint256)
参数说明：
address ctAddress CT市场地址；

返回值：
uint256 陪审团人数；
```

#### 查看CT市场的陪审团地址

```
function jurorList(address ctAddress) external view returns (address[] memory)
参数说明：
address ctAddress CT市场地址；

返回值：
address[] memory；  陪审团的地址数组；
```

#### 查看CT市场的陪审团的投票详情

````
function jurorVotes(address ctAddress) external view returns (Vote[] memory)
参数说明：
address ctAddress CT市场地址；

返回值：
Vote[] memory  陪审团的投票详情；
````

#### 查看CT市场的标记市场的总押金

```
function totalFlaggerDeposit(address ctAddress) external view returns (uint256)
参数说明：
address ctAddress CT市场地址；

返回值：
uint256 标记市场的总押金；
```

#### 查看CT市场的创建市场的押金

```
function totalCreatorDeposit(address ctAddress) external view returns (uint256)
参数说明：
address ctAddress CT市场地址；

返回值：
uint256 创建市场的押金；
```

#### 查看CT市场的下一次能够标记市场的时间

```
function nextFlaggableDate(address ctAddress) external view returns (uint256)
参数说明：
address ctAddress CT市场地址；

返回值：
uint256 下一次能够标记市场的时间；
```

#### 查看CT市场的标记市场的时间段

```
function flaggingPeriod(address ctAddress) external view returns (uint256 start, uint256 end)
参数说明：
address ctAddress CT市场地址；

返回值：
uint256 start  标记市场的起始时间；
uint256 end    标记市场的结束时间；
```

#### 查看CT市场投票的时间段

````
function votingPeriod(address ctAddress) external view returns (uint256 start, uint256 end)
参数说明：
address ctAddress CT市场地址；

返回值：
uint256 start  投票的起始时间；
uint256 end    投票的结束时间；
````

#### 查看CT市场申诉的时间段

```
function appealingPeriod(address ctAddress) external view returns (uint256 start, uint256 end)
参数说明：
address ctAddress CT市场地址；

返回值：
uint256 start  申诉的起始时间；
uint256 end    申诉的结束时间；
```

#### 查看CT市场申诉阶段

```
function appealRound(address ctAddress) external view returns (uint8)
参数说明：
address ctAddress CT市场地址；

返回值：
uint8 申诉阶段
```

#### 查看CT市场的投票数

```
function ballots(address ctAddress) external view returns (uint8)
参数说明：
address ctAddress CT市场地址；

返回值：
uint8 CT市场的投票数
```

#### 查看SmartUp平台的CT市场数目

```
function marketSize() external view returns (uint256)
返回值：
uint256  CT市场数目
```

#### 添加SmartUp会员

```
function addMember(address member) public onlyExistingMarket returns (uint256)
参数说明：
address member  要添加的地址

返回值：
uint256   添加地址所在的位置
```

