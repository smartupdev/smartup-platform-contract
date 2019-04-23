## CT 市场接口说明

#### 购买CT

```
function receiveApproval(address sutOwner, uint256 approvedSutAmount, address token, bytes calldata extraData) external
参数说明：
address sutOwner  购买的地址；
uint256 approvedSutAmount  允许转出的SUT金额；
address token SUT地址
bytes calldata extraData 买入的其他参数；

事件1：
Transfer(address indexed from, address indexed to, uint256 value)
参数说明：
address indexed from  发起转账的人
address indexed to   转账去处
uint256 value  转账的金额
事件2：
BuyCt(address _ctAddress, address _buyer, uint256 _setSut, uint256 _costSut, uint256 _ct)
参数说明：
address _ctAddress  ct市场地址
address _buyer      购买ct的地址
uint256 _setSut     设置转账的金额
uint256 _costSut    购买ct消耗sut的金额
uint256 _ct         买到的ct数量
```

#### 发起内容提案

```
function propose(uint8 choiceNum, uint8 validTime) external returns (bytes32 _proId)
参数说明：
uint8 choiceNum 投票的选项数目
uint8 validTime 内容提案有效时间

返回值：
bytes32 _proposalId  投票的ID

事件：
NewProposal(address _ctAddress, address _proposer, bytes32 _proId);
参数说明：
address _ctAddress   ct市场地址
address _proposer    发起内容提案的人
bytes32 _proId       propose ID
```

#### 对内容提案进行投票

```
function voteForProposal(uint8 mychoice, uint256 ctAmount, bytes32 _proposalId) external
参数说明：
uint8 mychoice 我的选项
uint256 ctAmount 投注CT数量
bytes32 _proposalId 投注的id；

事件：
NewVoter(address _ctAddress, uint8 _choice, uint256 _ct, address _voter, bytes32 _proId);
参数说明：
address _ctAddress   ct市场的地址
uint8 _choice        投票的选项
uint256 _ct          投的ct数量
address _voter       投票人地址
bytes32 _proId       投票的 propose ID 
```

#### 内容提案结束取回CT

```
withdrawProposalCt(bytes32 _proposalId)external
参数说明：
bytes32 _proposalId 投票的ID

事件：
WithDraw(address _ctAddress, address _drawer, uint256 _totoal, bytes32 _proId);
参数说明：
address _ctAddress  ct市场地址
address _drawer     发起调用的地址
uint256 _totoal     统计的ct数量
bytes32 _proId      propose ID
```

#### 获取投票内容详情

```
function getProposal(bytes32 _proposalId) external view returns(uint256 _validTime, uint256[] memory voteDetails, address[] memory _voters, address _origin)
参数说明：
bytes32 _proposalId  投票ID

返回值：
uint256 _validTime 投票有效期；
uint256[] memory voteDetails  各项投票的结果；
address[] memory _voters； 投票地址详情；
address _origin  投票发起人；
```

#### 发起支出SUT请求

```
function proposePayout(uint256 amount) external
参数说明：
uint256 amount  请求支出SUT的数目；

事件:
ProposePayout(address _ctAddress, address _proposer, uint256 _amount);
参数说明：
address _ctAddress  ct市场地址
address _proposer   发起支出请求的地址
uint256 _amount     发起支出的sut数量
```

#### 查看投票时间段

```
function votingPeriod() external view returns (uint256 start, uint256 end)
返回值：
uint256 start 开始时间；
uint256 end   结束时间；
```

#### 查看陪审团地址详情

```
function jurors() external view returns (address[] memory)
返回值：
address[] memory  陪审团地址详情
```

#### 查看陪审团投票详情

```
function jurorVotes() external view returns (uint8[] memory)
返回值：
uint8[] memory 投票详情
```

#### 陪审团进行投票

```
function vote(bool approve) external
参数说明：
bool approve 是否同意

事件:
JurorVote(address _ctAddress, address _juror, bool _approve);
参数说明：
address _ctAddress   ct市场地址
address _juror       投票的地址
bool _approve        是否同意（true 同意， false 不同意）
```

#### 对投票结果进行总结

```
function conclude() external
事件1：(仅支出请求成功触发)
Transfer(address indexed from, address indexed to, uint256 value)
参数说明：
address indexed from  发起转账的人
address indexed to   转账去处
uint256 value  转账的金额
事件2：CtConclude(address _ctAddress, uint256 _sutAmount, bool _success);
参数说明：
address _ctAddress   ct市场地址
uint256 _sutAmount   支出的sut数量
bool _succes         是否成功（true 成功， false 失败）
```

#### 解散市场

```
function dissolve() external 
事件1：(会有多数个此事件)
Transfer(address indexed from, address indexed to, uint256 value)
参数说明：
address indexed from  发起转账的人
address indexed to   转账去处
uint256 value  转账的金额
事件2:
DissolveMarket(address _ctAddress,  uint256 _sutAmount);
参数说明:
address _ctAddress ct市场地址
uint256 _sutAmount  解散时转出的sut总量
```

#### 卖出CT

```
function sell(uint256 ctAmount) public
参数说明：
uint256 ctAmount 卖出的CT的量

事件1：(会有多数个此事件)
Transfer(address indexed from, address indexed to, uint256 value)
参数说明：
address indexed from  发起转账的人
address indexed to   转账去处
uint256 value  转账的金额
事件2：
SellCt(address _ctAddress, address _sell, uint256 _sut, uint256 _ct);
参数说明：
address _ctAddress ct市场地址
address _sell 卖出ct的地址
uint256 _sut   换得的sut数量
uint256 _ct    卖出ct的数量
```

#### 买入时查询对应的价格

```
 function bidQuote(uint256 ctAmount) public view returns (uint256)
 参数说明：
 uint256 ctAmount  要购买的CT数目
 
 返回值：
 uint256 对应要花费的SUT数目
```

#### 卖出时查询对应的价格

````
function askQuote(uint256 ctAmount) public view returns (uint256) 
参数说明：
uint256 ctAmount 要卖出的 CT 的量

返回值：
uint256  能兑换的SUT价格
````

