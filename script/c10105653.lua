function c10105653.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,86188410,59793705,false,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE+LOCATION_HAND,0,Duel.SendtoGrave,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--attackall
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c10105653.efilter)
	c:RegisterEffect(e3)
    	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10105653,2))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,10105653)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c10105653.recon)
	e4:SetTarget(c10105653.retg)
	e4:SetOperation(c10105653.reop)
	c:RegisterEffect(e4)
end
function c10105653.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c10105653.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)
end
function c10105653.filter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c10105653.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105653.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c10105653.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c10105653.filter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc then return end
	local atk=tc:GetTextAttack()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and atk>0 then
		Duel.BreakEffect()
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end