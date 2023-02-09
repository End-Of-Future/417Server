--红龙
function c10105600.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,74677422,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),1,true)
	--code
	aux.EnableChangeCode(c,74677422,LOCATION_MZONE)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105600,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,10105600)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c10105600.target)
	e1:SetOperation(c10105600.operation)
	c:RegisterEffect(e1)
	--Normal monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
 --不被效果破坏
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10105600,0))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_BATTLE_DESTROYED)
	e5:SetCountLimit(1,10107600)
	e5:SetCondition(c10105600.damcon)
	e5:SetTarget(c10105600.damtg)
	e5:SetOperation(c10105600.damop)
	c:RegisterEffect(e5)
end
c10105600.material_setcode=0x3b
function c10105600.red_eyes_fusion_check(tp,sg,fc)
	return aux.gffcheck(sg,Card.IsFusionCode,74677422,Card.IsRace,RACE_DRAGON)
end
function c10105600.eqcon(e)
	return Duel.GetAttacker():IsSetCard(0x3b)
end
function c10105600.filter(c)
	return c:IsCode(52684508) and c:IsAbleToHand()
end
function c10105600.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105600.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10105600.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105600.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10105600.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10105600.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c10105600.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end