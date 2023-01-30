function c10105409.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c10105409.tg)
	e2:SetValue(800)
	c:RegisterEffect(e2)
    	 --draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105409,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,10105409)
	e3:SetCost(c10105409.drcost)
	e3:SetTarget(c10105409.drtg)
	e3:SetOperation(c10105409.drop)
	c:RegisterEffect(e3)
    	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10105409,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1,101054090)
	e4:SetCondition(c10105409.bdcon)
	e4:SetTarget(c10105409.bdtg)
	e4:SetOperation(c10105409.bdop)
	c:RegisterEffect(e4)
end
function c10105409.tg(e,c)
	return c:IsLevel(1) and  c:IsRace(RACE_ZOMBIE)
end
function c10105409.costfilter1(c)
	return c:IsLevel(1) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c10105409.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105409.costfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.DiscardHand(tp,c10105409.costfilter1,1,1,REASON_DISCARD+REASON_COST)
end
function c10105409.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10105409.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c10105409.cfilter(c,tp)
	local rc=c:GetReasonCard()
	return c:IsReason(REASON_BATTLE) and c:IsPreviousControler(tp) and c:IsSetCard(0x1f1)
		and rc and rc:IsControler(1-tp) and rc:IsRelateToBattle()
end
function c10105409.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local dc=eg:Filter(c10105409.cfilter,nil,tp):GetFirst()
	if dc then
		e:SetLabelObject(dc:GetReasonCard())
		return true
	else return false end
end
function c10105409.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c10105409.bdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end