--圣光飞龙-圣芒裂空击
function c27819020.initial_effect(c) 
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c27819020.mfilter),1)
	c:EnableReviveLimit()   
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819020,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c27819020.descon)
	e1:SetTarget(c27819020.destg)
	e1:SetOperation(c27819020.desop)
	c:RegisterEffect(e1)	 
	--atk 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c27819020.atkcon)
	e2:SetOperation(c27819020.atkop)
	c:RegisterEffect(e2) 
end 
c27819020.SetCard_XXLight=true  
c27819020.SetCard_XXLightDragon=true 
function c27819020.mfilter(c) 
	return c.SetCard_XXLight 
end  
function c27819020.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c27819020.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c27819020.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) 
	local dg=g:Filter(Card.IsRelateToEffect,nil,e) 
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c27819020.ckfil(c) 
	return c:IsPreviousLocation(LOCATION_ONFIELD)  
end 
function c27819020.atkcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c27819020.ckfil,1,nil) 
end 
function c27819020.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,27819020) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(900)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
end 





