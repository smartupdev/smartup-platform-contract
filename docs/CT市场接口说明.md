## CT 市场接口说明

#### 购买CT

```
function receiveApproval(address sutOwner, uint256 approvedSutAmount, address token, bytes calldata extraData) external
参数说明：
address sutOwner  购买的地址；
uint256 approvedSutAmount  允许转出的SUT金额；
address token SUT地址
bytes calldata extraData 买入的其他参数；

事件：
Transfer(from, to, value)
buy(sutOwner, approvedSutAmount, bytesToUint256(extraData, 0));
```

#### 发起内容提案

```
function propose(uint8 choiceNum, uint8 validTime) external returns (bytes32 _proId)
参数说明：
uint8 choiceNum 投票的选项数目
uint8 validTime 

返回值：
bytes32 _proposalId  投票的ID

事件：
 NewProposal(msg.sender, _proposalId);
```

#### 对内容提案进行投票

```
function voteForProposal(uint8 mychoice, uint256 ctAmount, bytes32 _proposalId) external
参数说明：
uint8 mychoice 我的选项
uint256 ctAmount 投注CT数量
bytes32 _proposalId 投注的id；

事件：
NewVoter(mychoice, ctAmount, msg.sender, _proposalId);
```

#### 内容提案结束取回CT

```
withdrawProposalCt(bytes32 _proposalId)external
参数说明：
bytes32 _proposalId 投票的ID

事件：
WithDraw(voter, total, _proposalId); 
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
```

#### 对投票结果进行总结

```
function conclude() external
```

#### 解散市场

```
function dissolve() external 
```

#### 卖出CT

```
function sell(uint256 ctAmount) public
参数说明：
uint256 ctAmount 卖出的CT的量

事件：
Transfer(from, to, value)；
SellCt(address(this), seller, tradedSut, ctAmount);
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

