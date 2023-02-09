function c10105603.initial_effect(c)
--fusion material
	aux.AddFusionProcFun2(c,c10105603.mfilter1,c10105603.mfilter2,true)
	c:EnableReviveLimit()
	--decrease atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c10105603.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
    	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10105603.discon)
	e3:SetOperation(c10105603.disop)
	c:RegisterEffect(e3)
    	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10105603,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,10105603)
	e4:SetTarget(c10105603.thtg)
	e4:SetOperation(c10105603.thop)
	c:RegisterEffect(e4)
    end
    c10105603.material_setcode=0x3b
function c10105603.mfilter1(c)
	return c:IsFusionSetCard(0x3b) and c:IsLevel(7)
end
function c10105603.mfilter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevelBelow(6)
end
function c10105603.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
    function c10105603.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b)
end
function c10105603.atkval(e,c)
	return Duel.GetMatchingGroupCount(c10105603.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*-500
end
function c10105603.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10105603.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local atk=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTACK)
	return re:IsActiveType(TYPE_MONSTER) and atk==0
end
function c10105603.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c10105603.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return aux.dsercon(e) and c==Duel.GetAttacker() and c:IsStatus(STATUS_OPPO_BATTLE)
		and bc and bc:IsOnField() and bc:IsRelateToBattle()
end
function c10105603.thfilter(c)
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10105603.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105603.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105603.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105603.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end