--骂骂咧咧的三文鱼烙饭
local m=30600025
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,30600001,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),1,63,true,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_ONFIELD,LOCATION_ONFIELD,Duel.Release,REASON_COST+REASON_MATERIAL)
	--recover
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_PZONE)
	e0:SetLabel(1)
	e0:SetCondition(cm.lpcon)
	e0:SetOperation(cm.lpop1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetLabel(1)
	e1:SetCondition(cm.lpcon1)
	e1:SetOperation(cm.lpop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetLabel(1)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(cm.lpcon2)
	e3:SetOperation(cm.lpop2)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--怪兽效果
	--spsummon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.fuslimit)
	c:RegisterEffect(e4)
	--cannot fusion material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--leave
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCountLimit(1,m)
	e6:SetTarget(cm.rectg)
	e6:SetOperation(cm.recop)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_DISABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_PZONE,LOCATION_PZONE)
	e7:SetTarget(cm.distarget)
	c:RegisterEffect(e7)
	--disable effect
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAIN_SOLVING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetOperation(cm.disoperation)
	c:RegisterEffect(e8)
	--pendulum
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,3))
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_DESTROYED)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCondition(cm.pencon)
	e9:SetTarget(cm.pentg)
	e9:SetOperation(cm.penop)
	c:RegisterEffect(e9)
end
function cm.cfilter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsFaceup()
end
function cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	return cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.lpop1(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(cm.cfilter,nil,1-tp)
	local rnum=lg:GetSum(Card.GetAttack)
	Duel.Recover(tp,rnum,REASON_EFFECT)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(cm.cfilter,nil,1-tp)
	local g=e:GetLabelObject()
	if g==nil or #g==0 then
		lg:KeepAlive()
		e:SetLabelObject(lg)
	else
		g:Merge(lg)
	end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function cm.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.lpop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(m)
	local lg=e:GetLabelObject():GetLabelObject()
	local rnum=lg:GetSum(Card.GetAttack)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
	lg:DeleteGroup()
	Duel.Recover(tp,rnum,REASON_EFFECT)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local de1=e:GetHandler():GetBaseAttack()
	local de2=e:GetHandler():GetBaseDefense()
	Duel.SetTargetParam((de1+de2)/2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,(de1+de2)/2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,(de1+de2)/2)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Duel.Recover(1-p,d,REASON_EFFECT)
end
function cm.distarget(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_PENDULUM)
end
function cm.disoperation(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(tl,LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_PENDULUM) then
		Duel.NegateEffect(ev)
	end
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end





