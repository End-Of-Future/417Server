--圣光飞龙-奇迹之光
function c27819046.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819046,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,27819046)
	e1:SetCondition(c27819046.discon) 
	e1:SetTarget(c27819046.distg)
	e1:SetOperation(c27819046.disop)
	c:RegisterEffect(e1)
end
c27819046.SetCard_XXLight=true   
c27819046.SetCard_XXLightDragon=true   
function c27819046.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c27819046.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
		and ep==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsExistingMatchingCard(c27819046.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end 
function c27819046.stfil(c) 
	return c.SetCard_XXLight and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end 
function c27819046.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819046.stfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c27819046.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c27819046.stfil,tp,LOCATION_DECK,0,1,nil) then
	Duel.BreakEffect() 
	local tc=Duel.SelectMatchingCard(tp,c27819046.stfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	end
end
















