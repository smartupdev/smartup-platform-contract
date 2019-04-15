## NTT 合约接口说明

#### 关于NTT

````
1.NTT为smartUp平台的信用分合约；
2.所有账户默认初始值为100；
3.Grader有设置用户信用值的权限；
4.owner可设置或者取消Grader；
5.owner可以更换
````

#### 申请新的Owner更换请求

````
function initiateOwnershipTransfer(address newOwner) external onlyOwner 
参数说明：
address newOwner 要更换新的owner地址
````

####  取消申请的Owner更换请求

```
function cancelOwnershipTransfer() external onlyOwner
```

#### 接受成为新的Owner

```
function confirmOwnershipTransfer() external
```

#### 重置Owner为address（0）

````
function renounceOwnership() public onlyOwner
事件：
OwnershipTransferred(_owner, address(0))
````

#### 查看当前Owner

```
function owner() public view returns (address)
返回值：
address  当前owenr地址
```

#### 添加Grader

```
function addGrader(address grader) external onlyOwner
参数说明：
address grader 新添加的Grader地址

事件：
AddGrader(grader)
```

#### 移除Grader

```
function removeGrader(address grader) external onlyOwner
参数说明：
address  grader 移除的地址

事件：
RemoveGrader(grader)
```

#### 查看信用分

```
function checkCredit(address user) public view returns (uint256)
参数说明：
address user 所查看的地址

返回值：
uint256  信用分数
```

#### 提升信用分

```
function raiseCredit(address user, uint256 score) external whenMigrationUnstarted onlyGrader
参数说明：
address user 所要提升的地址
uint256 score 所要增加的分数

事件：
RaiseCredit(user, score);
```

#### 减少信用分

```
function lowerCredit(address user, uint256 score) external whenMigrationUnstarted onlyGrader
参数说明：
address user 所要减少信用分的地址
uint256 score 所要减少的分数

事件：
LowerCredit(user, score)；
```

#### owner 调整默认的信用分值

````
function adjustDefaultNtt(uint256 newDefault) external onlyOwner
参数说明：
uint256 newDefault 所设置的默认信用分值

事件：
AdjustDefaultNtt(newDefault)
````

#### 查看账户是否能进行当前操作

````
function isAllow(address user, string calldata action) external view returns (bool)
参数说明：
address user 账户地址
string calldata action 查询的操作

返回值：
bool
true 能进行当前操作
false 不能进行当前操作
````

#### 设置行为要求的NTT分数值

```
function adjustNttRequirement(string calldata action, uint256 min) external onlyOwner
参数说明：
string  calldata action   所要设置的行为描述
uint256 min  ntt分数值

事件：
SetNttRquirement(action, min)
```

